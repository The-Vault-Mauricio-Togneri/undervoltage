import {UserRecord} from 'firebase-admin/auth';
import {MatchStatus} from '../types/match-status';
import {getDatabase} from 'firebase-admin/database';
import {Player, Players} from './player';
import {Round} from './round';
import {Card} from './card';
import {Hand, Hands} from './hand';

export class Match {
  constructor(
    public id: string,
    public numberOfPlayers: number,
    public maxPoints: number,
    public createdAt: Date,
    public creator: string,
    public status: MatchStatus,
    public players: Players,
    public roundCount: number,
    public round: Round,
  ) {}

  public get playersJoined(): number {
    return this.players.length;
  }

  static new(params: {
    creator: UserRecord,
    numberOfPlayers: number,
    maxPoints: number,
  }): Match {
    const players = new Players();
    players.add(Player.fromUser(params.creator));

    return new Match(
        '',
        params.numberOfPlayers,
        params.maxPoints,
        new Date(),
        params.creator.uid,
        'waitingForPlayers',
        players,
        0,
        new Round(),
    );
  }

  static async load(matchId: string) {
    const snapshot = await getDatabase().ref(`matches/${matchId}`).get();

    if (snapshot.exists()) {
      return Match.parse(snapshot.toJSON());
    } else {
      throw new Error(`Match with ID "${matchId}" does not exist`);
    }
  }

  static parse(data: any): Match {
    return new Match(
        data['id'],
        data['numberOfPlayers'],
        data['maxPoints'],
        new Date(data['createdAt']),
        data['creator'],
        data['status'],
        Players.parse(data['players']),
        data['roundCount'],
        Round.parse(data['round']),
    );
  }

  public async create() {
    this.id = getDatabase().ref('matches').push().key ?? '';
    await this.update();

    return this.id;
  }

  public async join(user: UserRecord) {
    if (this.players.has(user.uid)) {
      return;
    }

    if (this.playersJoined < this.numberOfPlayers) {
      this.players.add(Player.fromUser(user));

      if (this.playersJoined === this.numberOfPlayers) {
        this.status = 'playing';

        for (const player of this.players.list) {
          player.setStatus('playing');
        }

        this.roundCount++;
        this.round = Round.new(this.players);
      }

      await this.update();
    } else {
      throw new Error('Match is full');
    }
  }

  private async update() {
    const matchesRef = getDatabase().ref(`matches/${this.id}`);
    await matchesRef.update(this.json());
  }

  public get isBlocked() {
    return ((this.round.discardPile.length > 0) && this.allPlayersBlocked(this.round.playersHand, this.round.lastCard));
  }

  private allPlayersBlocked(hands: Hands, topCard: Card): boolean {
    for (const hand of hands.list) {
      if (!this.playerBlocked(hand, topCard)) {
        return false;
      }
    }

    return hands.length > 0;
  }

  private playerBlocked(hand: Hand, topCard: Card): boolean {
    if (hand.hiddenPile.length === 0) {
      return !this.canPlayCards(hand.revealedPile, topCard);
    } else {
      return false;
    }
  }

  private canPlayCards(cards: Card[], topCard: Card): boolean {
    for (const card of cards) {
      if (topCard.canAccept(card)) {
        return true;
      }
    }

    return false;
  }

  public removeCard(playerId: string, cardId: string) {
    const hand = this.round.playersHand.of(playerId);
    hand.removeCard(cardId);
  }

  public async playCard(playerId: string, cardId: string) {
    const topCard = this.round.lastCard;
    const revealedPile = this.round.playersHand.of(playerId).revealedPile;

    for (const card of revealedPile) {
      if (card.id === cardId) {
        if (topCard.canAccept(card)) {
          const matchesRef = getDatabase().ref(`matches/${this.id}`);
          await matchesRef.transaction((data: any) => {
            if (data) {
              const match = Match.parse(data);
              match.round.discardPile.push(card);
              match.removeCard(playerId, cardId);

              return match.json();
            } else {
              return this.json();
            }
          }, (error, committed) => {
            if (error) {
              console.log('Transaction failed abnormally!', error);
            } else if (!committed) {
              console.log('We aborted the transaction (because ada already exists).');
            } else {
              console.log('User ada added!');
            }
          },
          true);
          break;
        }
      }
    }
  }

  public json() {
    return {
      id: this.id,
      numberOfPlayers: this.numberOfPlayers,
      maxPoints: this.maxPoints,
      createdAt: this.createdAt,
      creator: this.creator,
      status: this.status,
      players: this.players.json(),
      roundCount: this.roundCount,
      round: this.round.json(),
    };
  }
}
