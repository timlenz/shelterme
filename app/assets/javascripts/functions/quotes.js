$(function(){

  // Populate footer quote
  $('div .quote').html(function() {
    var randSeed = Math.floor(Math.random()*53);
    var quotes = ["I have found the paradox that if I love until it hurts, then there is no hurt, but only more love. -Mother Teresa",
                  "Unless someone like you cares a whole awful lot, nothing is going to get better.  It's not. -Dr. Seuss",
                  "Act as if what you do makes a difference.  It does. -William James",
                  "Being good is commendable, but only when it is combined with doing good is it useful. -Unknown",
                  "The purpose of life is not to be happy - but to matter, to be productive, to be useful, to have it make some difference that you have lived at all. -Leo Rosten",
                  "It is the greatest of all mistakes to do nothing because you can only do little - do what you can. -Sydney Smith",
                  "The true meaning of life is to plant trees, under whose shade you do not expect to sit. -Nelson Henderson",
                  "Dare to reach out your hand into the darkness, to pull another hand into the light. -Norman B. Rice",
                  "The difference between a helping hand and an outstretched palm is a twist of the wrist. -Laurence Leamer",
                  "I am only one, but I am one.  I cannot do everything, but I can do something.  And I will not let what I cannot do interfere with what I can do. -Edward Everett Hale",
                  "How far that little candle throws his beams! So shines a good deed in a naughty world. -William Shakespeare",
                  "I expect to pass through life but once.  If therefore, there be any kindness I can show, or any good thing I can do to any fellow being, let me do it now, and not defer or neglect it, as I shall not pass this way again. -William Penn",
                  "How wonderful it is that nobody need wait a single moment before starting to improve the world. -Anne Frank",
                  "Be an opener of doors for such as come after thee, and do not try to make the universe a blind alley. -Ralph Waldo Emerson",
                  "We can do no great things, only small things with great love. -Mother Teresa",
                  "Nobody can do everything, but everyone can do something. -Unknown",
                  "Everyone thinks of changing the world, but no one thinks of changing himself. -Leo Tolstoy",
                  "Nobody made a greater mistake than he who did nothing because he could only do a little. -Edmund Burke",
                  "It seems to me that any full grown, mature adult would have a desire to be responsible, to help where he can in a world that needs so very much, that threatens us so very much. -Norman Lear",
                  "Live simply that others might simply live. -Elizabeth Ann Seton",
                  "We make a living by what we get, but we make a life by what we give. -Winston Churchill",
                  "I wondered why somebody didn't do something.  Then I realized, I am somebody. -Unknown",
                  "Do not commit the error, common among the young, of assuming that if you cannot save the whole of mankind you have failed. -Jan de Hartog",
                  "Love the earth and sun and animals, Despise riches, give alms to everyone that asks, Stand up for the stupid and crazy, Devote your income and labor to others... And your very flesh shall be a great poem. -Walt Whitman",
                  "Thousands of candles can be lighted from a single candle, and the life of the candle will not be shortened.  Happiness never decreases by being shared. -Buddha",
                  "Our prayers for others flow more easily than those for ourselves.  This shows we are made to live by charity. -C.S.Lewis",
                  "Not only must we be good, but we must also be good for something. -Henry David Thoreau",
                  "Sometimes a man imagines that he will lose himself if he gives himself, and keep himself if he hides himself.  But the contrary takes place with terrible exactitude. -Ernest Hello",
                  "Real joy comes not from ease or riches or from the praise of men, but from doing something worthwhile. -Wilfred Grenfell",
                  "Things of the spirit differ from things material in that the more you give the more you have. -Christopher Morley",
                  "A bone to the dog is not charity.  Charity is the bone shared with the dog, when you are just as hungry as the dog. -Jack London",
                  "Service to others is the rent you pay for your room here on earth. -Muhammed Ali",
                  "Do not let what you cannot do interfere with what you can do. -John Wooden",
                  "You give but little when you give of your possessions.  It is when you give of yourself that you truly give. -Kahlil Gibran",
                  "Great opportunities to help others seldom come, but small ones surround us every day. -Sally Koch",
                  "If you do a good job for others, you heal yourself at the same time, because a dose of joy is a spiritual cure. -Dietrich Bonhoeffer",
                  "No joy can equal the joy of serving others. -Sai Baba",
                  "What we have done for ourselves alone dies with us; what we have done for others and the world remains and is immortal. -Albert Pike",
                  "I've learned that you shouldn't go through life with a catchers mitt on both hands.  You need to be able to throw something back. -Maya Angelou",
                  "The greatest good you can do for another is not just to share your riches but to reveal to him his own. -Benjamin Disraeli",
                  "The work an unknown good man has done is like a vein of water flowing hidden underground, secretly making the ground green. -Thomas Carlyle",
                  "If the world seems cold to you, kindle fires to warm it. -Lucy Larcom",
                  "Every action in our lives touches on some chord that will vibrate in eternity. -Edwin Hubbel Chapin",
                  "The world is moved along, not only by the mighty shoves of its heroes, but also by the aggregate of tiny pushes of each honest worker. -Helen Keller",
                  "There are many in the world who are dying for a piece of bread, but there are many more dying for a little love. -Mother Teresa",
                  "If you pursue good with labor, the labor passes away but the good remains; if you pursue evil with pleasure, the pleasure passes away and the evil remains. -Cicero",
                  "If you think you are too small to be effective, you have never been in bed with a mosquito. -Betty Reese",
                  "There are two ways of spreading light - to be the candle or the mirror that reflects it. -Edith Wharton",
                  "Every man feels instinctively that all the beautiful sentiments in the world weigh less than a single lovely action. -Lowell",
                  "Generosity is not giving me that which I need more than you do, but it is giving me that which you need more than I do. -Kahlil Gibran",
                  "Never doubt that a small group of thoughtful, committed citizens can change the world. -Margaret Mead",
                  "The difference between friends and pets is that friends we allow into our company, pets we allow into our solitude. -Robert Brault"]
    var randQuote = quotes[randSeed];
    return randQuote;
  });
  
});