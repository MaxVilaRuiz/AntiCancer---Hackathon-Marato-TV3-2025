enum Category {
  animals,
  fruitsVegetables,
  colors,
}

Map<Category, String> categoryNames =
{
    Category.animals: "Animals",
    Category.fruitsVegetables: "Fruites i verdures",
    Category.colors: "Colors"
};

bool correctCategory(String word, Category category)
{
    return categoryWords[category]?.contains(word) ?? false;
}

final Map<Category, Set<String>> categoryWords = {
  Category.animals: {
    // ===== Español =====
    "perro","perra","gato","gata","caballo","yegua","vaca","toro",
    "cerdo","oveja","cabra","cordero","leon","tigre","elefante",
    "jirafa","mono","gorila","chimpance","oso","lobo","zorro",
    "conejo","liebre","raton","rata","hamster","ardilla",
    "pajaro","canario","loro","aguila","halcon","paloma",
    "pez","tiburon","ballena","delfin","foca",
    "tortuga","lagarto","iguana","camaleon",
    "serpiente","cobra","piton",
    "rana","sapo",
    "pollo","gallina","gallo","pato","oca","pavo",
    "caballito","pulpo","calamar","cangrejo","langosta",

    // ===== Catalán =====
    "gos","gat","cavall","euga","bou",
    "porc","ovella","xai","lleo","elefant",
    "girafa","mona","goril·la","ximpanzé","os","llop","guineu",
    "conill","llebre","ratoli","esquirol",
    "ocell","canari","lloro","falcó","colom",
    "peix","tauró","balena","dofi","llangardaix","camaleó",
    "serp","pitó",
    "granota","gripau",
    "pollastre","gall","ànec","indiot",

    // ===== Inglés =====
    "dog","puppy","cat","kitten","horse","mare","cow","bull",
    "pig","sheep","goat","lamb","lion","tiger","elephant",
    "giraffe","monkey","gorilla","chimpanzee","bear","wolf","fox",
    "rabbit","hare","mouse","rat","squirrel",
    "bird","canary","parrot","eagle","hawk","pigeon",
    "fish","shark","whale","dolphin","seal",
    "turtle","lizard","chameleon",
    "snake","python",
    "frog","toad",
    "chicken","hen","rooster","duck","goose","turkey",
    "octopus","squid","crab","lobster",
  },

  Category.fruitsVegetables: {
    // ===== Español =====
    "manzana","pera","platano","banana","naranja","mandarina",
    "limon","lima","fresa","frutilla","cereza","uva",
    "melon","sandia","pina","mango","papaya","kiwi",
    "tomate","lechuga","espinaca","acelga",
    "zanahoria","cebolla","ajo","puerro",
    "patata","papa","boniato","batata",
    "pepino","pimiento","berenjena","calabacin",
    "brocoli","coliflor","repollo","col",
    "maiz","choclo","guisante","arveja",
    "lenteja","garbanzo","judia","alubia",
    "seta","champiñon",

    // ===== Catalán =====
    "poma","platan","plàtan","taronja",
    "llimona","llima","maduixa","cirera","raim",
    "melo","sindria","pinya","papaia",
    "tomàquet","enciam","espinacs","bleda",
    "pastanaga","ceba","all","porro","moniato",
    "cogombre","pebrot","alberginia","carbasso","repol",
    "blat de moro","pesol",
    "llentia","cigró","mongeta",
    "bolet","xampinyó",

    // ===== Inglés =====
    "apple","pear","orange","mandarin",
    "lemon","lime","strawberry","cherry","grape","watermelon","pineapple",
    "tomato","lettuce","spinach","chard",
    "carrot","onion","garlic","leek",
    "potato","sweet potato",
    "cucumber","pepper","eggplant","zucchini",
    "broccoli","cauliflower","cabbage",
    "corn","pea",
    "lentil","chickpea","bean",
    "mushroom",
  },

  Category.colors: {
    // ===== Español =====
    "rojo","azul","verde","amarillo","negro","blanco","gris",
    "marron","rosa","morado","violeta","naranja",
    "turquesa","cian","magenta",
    "beige","crema","dorado","plateado",

    // ===== Catalán =====
    "vermell","blau","verd","groc","negre","blanc",
    "marro","lila","taronja",
    "beix","daurat","platejat",

    // ===== Inglés =====
    "red","blue","green","yellow","black","white","gray",
    "brown","pink","purple","violet","orange",
    "turquoise","cyan","cream","gold","golden","silver",
  },
};