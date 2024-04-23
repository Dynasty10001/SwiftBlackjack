//BY Kyle D (doerkson8556) & Cody S (steier1256)

//FUNCTIONS
//Function to create the deck
public func GetCardArray() -> [Card]
{
  var CardArray : [Card] = []
  
  for i in 1...4
  {
    for j in 1...13
    {
      var suit: String = "";
      switch(i)
      {
        case 1: suit="|    \u{2664}|";
        case 2: suit="|    \u{2661}|";
        case 3: suit="|    \u{2667}|";
        case 4: suit="|    \u{2662}|";
        default: print("ERROR on suit creation");
      }
      var cardName: String = ""
      var value: Int = 0
      switch(j)
      {
        case 1: cardName="| Ace |"; value = 1;
        case 2: cardName="|2    |"; value = 2;
        case 3: cardName="|3    |"; value = 3;
        case 4: cardName="|4    |"; value = 4;
        case 5: cardName="|5    |"; value = 5;
        case 6: cardName="|6    |"; value = 6;
        case 7: cardName="|7    |"; value = 7;
        case 8: cardName="|8    |"; value = 8;
        case 9: cardName="|9    |"; value = 9;
        case 10: cardName="|10   |"; value = 10;
        case 11: cardName="|Jack |"; value = 10;
        case 12: cardName="|Queen|"; value = 10;
        case 13: cardName="|King |"; value = 10;
        default: print("ERROR on CardName/Value creation")
       }
      CardArray.append(Card(CardName: cardName, Suit: suit, Value: value))
    }
  }
  CardArray.shuffle(); CardArray.reverse(); CardArray.shuffle(); // make sure it's good and shuffled
  return CardArray; 
}

//Deck Variable
public var Deck:[Card] = []

//Function to get a single card from the deck
public func GetCard() -> Card
{
  return Deck.removeFirst();
}

//Function to check for blackjack
public func CheckForBJ(cards :[Card]) -> Bool
{
  if (cards[0].Value == 1 && cards[1].Value == 10 || cards[0].Value == 10 && cards[1].Value == 1) {                                                                                               return true
  } 
  else {                                                                                           return false
  }
}

//Function for checking win/loss/draw if the player or dealer gets blackjack
public func BJEnd(dealerBJ : Bool, playerBJ : Bool, cards: [Card])
{
  if (playerBJ && dealerBJ)
  {
    print("Dealers Cards:")
    print(printHand(cards: cards))
    print("DOUBLE BLACKJACK!!!!")
    print("Draw!!!!")
  }
  else if (playerBJ){
    print("BLACKJACK!!!!!!")
  player.Balance += player.CurrentBet + (player.CurrentBet / 2);
  }
  else {
    print("Dealers Cards:")
    print(printHand(cards: cards))
     print("DEALER BLACKJACK!!!!!!")
    player.Balance -= player.CurrentBet;
  }
  
}

//helper function to print out a player or dealers current hand in a "fancy way"
public func printHand(cards :[Card]) -> String
{
  let top: String = " \u{2017}\u{2017}\u{2017}\u{2017}\u{2017} "
  let middle: String = "|     |"
  let bottom: String = " \u{203E}\u{203E}\u{203E}\u{203E}\u{203E} "
  var result: String = ""
  for i in 1...5
  {
    for card in cards
    {
      switch (i)
      {
        case 1: result += top
        case 2: result += card.CardName
        case 3: result += middle
        case 4: result += card.Suit
        case 5: result += bottom
        default : result = "no"
      }
    }
    result += "\n"
  }
  return result
}

// Function to check win/loos when the player and dealer turn is over
public func turnOver(player : Player, dealer: Dealer)
{
  if (player.calcPoints() > 21)
  {
    print("You Bust!\n")
    player.Balance -= player.CurrentBet
  } 
  else if (dealer.calcPoints() > 21)
  {  
    print("Dealer Bust!\n")
    player.Balance += player.CurrentBet;
  }
  else if (player.calcPoints() > dealer.calcPoints()) 
  {
    print("You Win!!!!!\n")
    player.Balance += player.CurrentBet;
  } 
  else 
  {
    print("Better luck next time\n")
    player.Balance -= player.CurrentBet
  }
}


//CLASSES
//----------Card Class----------
public class Card : CustomStringConvertible
{
  public var CardName: String;
  public var Suit: String;
  public var Value: Int;
  public var description: String
  {
    return "|\(self.CardName) of \(self.Suit)|"
  }

  public init(CardName: String, Suit: String, Value: Int)
  {
    self.CardName = CardName;
    self.Suit = Suit;
    self.Value = Value;
  }
}

//----------Player Class----------
public class Player
{
  public var Hand : [Card] = [];
  public var CurrentBet : Int = 0;
  public var Balance : Int = 100;

  public func calcPoints() -> Int
  {
    var count = 0;
    var aceCount = 0;
    for card in self.Hand
    {
      if (card.Value == 1){
        aceCount += 1
      } else {
        count += card.Value;
      }
    }
    
    if (aceCount > 0)
      {
        switch (aceCount)
        {
          case 1: 
          if (count > 10) {
            count += 1;
          } else {
            count += 11;
          }
          
          case 2: if (count >= 10) {
            count += 2;
          } else if (count <= 9){
            count += 12;
          }
          
          case 3: if (count >= 9) {
            count += 3;
          } else {
            count += 13;
          }
          
          case 4:  if (count >= 8) {
            count += 4;
          } else {
            count += 14;
          }
          default: print("UHHHH How'd we get to this point?\n What is life? \n What if bigfoot himself is blurry?\n");
        }
      }
    
    return count;
  }

  //Function that runs the players turn
  func PlayerTurn() -> ()
  {
    var fin: Bool = true;
    
      repeat
      {
        print("Your score: \(self.calcPoints())\n")
        print("What would you like to do:\n1) Hit\n2) Stay\nYour Move: ")
        let choice = String(readLine()!)
        switch(choice)
        {
          case "1": self.Hand.append(GetCard());
          case "2": fin = false;
          case "hit": self.Hand.append(GetCard());
          case "stay": fin = false;
          case "Hit": self.Hand.append(GetCard());
          case "Stay": fin = false;
          default: print("Invalid Move, try again")
        }
        print("Your Hand:")
        print(printHand(cards:player.Hand))
        if self.calcPoints() > 21
        {fin = false}
       
      } while (fin)

  }

  // function to reset the players bet and hand after the game ends
  public func reset()
  {
    self.Hand = []
    self.CurrentBet = 0;
  }
}

//----------Dealer Class----------
public class Dealer
{
  public var Hand : [Card] = []
  
  public func DealerTurn()
  {
    print("Dealers Cards:")
    print(printHand(cards:self.Hand))
    var count = calcPoints()
    while count < 17
    {
      print("Dealer Hits\n")
      self.Hand.append(GetCard()) // random card from card array
      count = calcPoints()
      print("Dealers Cards:")
      print(printHand(cards:self.Hand))
     
    }
    print("Dealers Points: \(count)")
  }

  public func calcPoints() -> Int
  {
    var count = 0;
    for card in self.Hand
    {
      count += card.Value;
    }
    return count;
  }

}

//GAME

print("Welcome to BlackJack Swift Edition\n");

print("To start type 'start',\nTo show the rules type 'rules' \n");
var start = String(readLine()!);
var player = Player()
while start == "rules"
{
  print("""
        BlackJack is a card game where the goal is to
        get to 21 points.\n
        if your cards total to over 21 points you bust and lose the round.
        if the dealer busts and you're not over 21 you win.
        if nobody busts then the winner is whoevers total points
        is closest to 21.\n
        if you have a 10/face card and an Ace
        that is considered a BlackJack and you will
        recieve your bet + 50% of it\n
        but if both you and the dealer have a BlackJack
        it is considered a draw and you will only recieve
        your original bet.\n
      """)
  print("To start type 'start',\nTo show the rules type 'rules' \n");
  start = String(readLine()!);
}

while start != "start"
{
  print("Okay maybe later\n\n")
  print("It's really fun \n\n")
  print("Are you sure you don't want to play? :( \n\n")
  print("To start type 'start': \n");
  start = String(readLine()!);
}

while start == "start"
{
  Deck = GetCardArray();
  let dealer = Dealer() //add cardArray to initialize
  dealer.Hand.append(GetCard());
  dealer.Hand.append(Card(CardName: "|\\/ \\/|", Suit: "|/\\ /\\|", Value: 0))
  print("Dealers Cards: \n")
  print(printHand(cards:dealer.Hand))
  dealer.Hand.removeLast()
  dealer.Hand.append(GetCard());
  player.Hand.append(GetCard());
  player.Hand.append(GetCard());
  let dealerBJ = CheckForBJ(cards: dealer.Hand)
  let playerBJ = CheckForBJ(cards: player.Hand)

repeat
    {
      print("\nCurrent Balance of $\(player.Balance)\nHow much would you like to bet?: ")
      let inputBet: Int = Int(readLine()!) ?? 0
      if (inputBet < 1 || inputBet > player.Balance)
      {
        print("Invalid Bet. Your bet must be a whole number Greater than 0 and less than or equal to your Current Balance of $\(player.Balance)\n")
      } else {player.CurrentBet = inputBet}
    } while (player.CurrentBet < 1 || player.CurrentBet > player.Balance)
  
  print("\nYour Hand: \n")
  print(printHand(cards:player.Hand))

  if (dealerBJ || playerBJ)
  {
    BJEnd(dealerBJ: dealerBJ, playerBJ: playerBJ, cards: dealer.Hand)
  } else {
    player.PlayerTurn()

    if (player.calcPoints() > 21) {turnOver(player : player, dealer: dealer)}
    else {
          dealer.DealerTurn()
          turnOver(player: player, dealer: dealer)
         }
  }
  if (player.Balance > 0)
  {
    print("Would you like to keep playing: Yes/No ")
    let keepPlaying = String(readLine()!);
    if( keepPlaying == "no" || keepPlaying == "No")
    {
      print("Thanks for playing!\n")
      player.reset();
      break;
    }
  } else {
    print("You have run out of money :(\n")
    print("Thanks for playing!\n")
    break
  }
  player.reset();
}


