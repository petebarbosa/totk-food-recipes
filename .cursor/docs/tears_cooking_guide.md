## Tears of the Kingdom Cooking

A complete, in-depth TotK Cooking System explanation

## Introduction

This   document   attempts   to    resume   and   explain   the   entirety   of   the   Cooking   system   of The Legend   of   Zelda:   Tears   of   the   Kingdom . It should be   100%   accurate,   but   I   cannot   guarantee   it   is.   If you   think   there's   an   error   somewhere,   please   let   me   know   on   Discord   (my   username   is   echocolat). While   this   explanation   uses   a   lot   of   data   from   the   game's   code   and   files,   it   will   not   always   follow   the order of operations the game does when calculating everything related to the cooking.

Let's   assume   we   already   chose   our   one   to   five   material(s).   I'll   go   through   the   cooking   of   the meal step by step to make it easier to understand.

## Resources

- -Tears of the Kingdom Cooking Calculator
- -Online version of the calculator above
- -Tears of the Kingdom Cooking Spreadsheet
- -Tears of the Kingdom Datamining server

## Getting the recipe

The   first   step   of   the   algorithm   is   to   find   what   kind   of   meal   our   one   to   five   material(s)   create. Firstly,   the   game   checks   how   many unique materials   are   present   in   your   combination.   For   example, a   meal   with   two   Acorns   and   one   Apple   has   two   unique   materials   (Apple   and   Acorn).   If   that   amount is    equal    to    one,   it    will    start    searching    in    the list    of    possible    meals   (more   about 𝑆𝑖𝑛𝑔𝑙𝑒𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡 how    it    actually    searches    in    the    list    in    a    bit).    Else,   it    will    start    searching    in    the list    of 𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡 possible   meals.   However,   if   the   game   fails   to   find   a   meal   in ,   and   if   one   of   the   materials 𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡 have the tag 1 , it also searches in . 𝐶𝑜𝑜𝑘𝑆𝑝𝑖𝑐𝑒 𝑆𝑖𝑛𝑔𝑙𝑒𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡

## Searching in 𝑆𝑖𝑛𝑔𝑙𝑒𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡

The   game   cycles   through   the   list   of   SingleRecipe   meals,   first   to   last,   and   does   a   bunch   of checks   for    each    to    determine    if    the   materials   match   the   meal's   requirements.   If   they   do   match   it, the    meal    is selected    and    the    'Getting    the    recipe'    step    ends.    SingleRecipes    only    have    one ,   which   basically   is   a   requirement   that   needs   to   be   met   for   the   meal   to   be   selected.   Such 𝑇𝑎𝑟𝑔𝑒𝑡𝐿𝑖𝑠𝑡 a    requirement    can    be    made    of    one    or    multiple    elements,    such    as    'Sneaky    River    Snail'    (one element   made   of   a   material),   or   'CookFish'   (one   element   made   of   a   cook   Tag),   or   even   'Acorn   OR Chickaloo    Tree    Nut'    (two    elements    made    of    two    materials).    If    the    unique    requirement    of    a SingleRecipe   is    met,    the    game    selects    the    meal    as    the    result,    and    goes    to    the    next    step.    If    the game   didn't   find   a   single   matching   SingleRecipe   at   the   end   of   the   cycle,   the   result   is   the   failed   meal actor   (e.g.   Dubious   Food),   its   effect   is   set   to   None,   its   effect   time   and   level   as   well   as   critical   rate are set to 0, its selling price is set to 2, and skip   to the Conclusion step .

1 An   actor   can   have   one   or   multiple   T ags   that   are   all   found   in   the   T ag.Product   RSDB.   A   bunch   of   T ags   are used    throughout    the    cooking    steps,    such    as    CookSpice,    CookEnemy,    CookFruit,    etc.    You    can    check    the 'primary'    cook    Tag of materials    in /Data/MaterialData.json    in    the    github    repository    or    in    the    cooking spreadsheet  .

## Searching in 𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡

Similarly   to ,   the   game   cycles   through   the   list   of   Recipe   meals,   first   to   last, 𝑆𝑖𝑛𝑔𝑙𝑒𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡 and   does    even    more    checks    to    determine    if   the   materials   match   the   meal's   requirements.   Unlike SingleRecipes,   Recipes   can   have   multiple s,   which   means   multiple   requirements   need 𝑇𝑎𝑟𝑔𝑒𝑡𝐿𝑖𝑠𝑡 to   be   met   for   the   meal   to   be   selected.   A   material   from   your   list   can   only   count   for   one   requirement (after    which,    it's    not    in    consideration    for    the    'Getting    the    recipe'    step    anymore).    For    example, Copious Mushroom Skewers has four requirements, 'CookMushroom', 'CookMushroom', 'CookMushroom' and 'CookMushroom',    which can be resumed    to 'CookMushroom    AND CookMushroom   AND   CookMushroom   AND   CookMushroom'.   A   single   mushroom   in   your   material list    can   only    fulfill    one    of    the    requirements,   after    that    it    can't    be    used   for   requirements   anymore. The   requirements   for can   still   have   multiple   elements,   which   means   the   full   requirement 𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡 'expression'   can   look   like   '(Raw   Meat   OR   Prime   Raw   Meat)   AND   CookFish'   (needs   either   a   Raw Meat   or    a    Prime    Raw    Meat,    as   well   as   a   fish).   If all requirements   of   a   Recipe   are   met,   the   game selects   the   meal   as   the   result,   and   goes   to   the   next   step.   If   the   game   doesn't   find   a   single   matching Recipe   at    the    end    of    the    cycle:    If    one    of   the   materials   has   CookSpice   and   there   are   at   least   two unique   cook   tags    among    the    materials,    the    game   searches   in as   stated   above. 𝑆𝑖𝑛𝑔𝑙𝑒𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡 Else,   result   is   the   failed   meal   actor   (e.g.   Dubious   Food),   its   effect   is   set   to   None,   its   effect   time   and level    as    well    as    critical   rate   are   set   to   0,   its   selling   price   is   set   to   2, and   skip   to   the   Conclusion step .    If    one    of    the    materials    has    CookSpice,    the    game    searches    in as   stated 𝑆𝑖𝑛𝑔𝑙𝑒𝑅𝑒𝑐𝑖𝑝𝑒𝐿𝑖𝑠𝑡 above.

## Getting the effect and its stats

This   step   generates   the   eventual   effect   of   the   meal   and   its   basic   statistics   (its   duration   if   it has   one    and    its    level).    Before    proceeding,    let's    get    a    quick    overview    of    the    different    effects    and their    own    properties.    Each    effect    has    a and    a ,    which    act    as    the    lowest    and    the 𝑀𝑖𝑛𝐿𝑣 𝑀𝑎𝑥𝐿𝑣 highest the effect level can    be. They    also have    a (we'll see    its use    later) and    a 𝑅𝑎𝑡𝑒 that   we   will   call from   now,   that   is   the   additional   level   the   meal   gets 𝑆𝑢𝑝𝑒𝑟𝑆𝑢𝑐𝑐𝑒𝑠𝑠𝐴𝑑𝑑𝑉𝑜𝑙𝑢𝑚𝑒 𝑆𝑆𝐴𝑉 in    certain    conditions   (we'll   see   later   too).   Effects   with   a   duration   also   have   a ,   we'll   also 𝐵𝑎𝑠𝑒𝑇𝑖𝑚𝑒 see   its   use   later.   You   can   click   this   link   to   access   a   spreadsheet   with   all   effects   and   their   properties. I    will    be   oversimplifying   the   process   to   make   it   easier   to   understand,   if   you   want   a   more   accurate description   (although   still   far   from   the   actual   code)   you   can   check   the   \_effect()   function   (and   below for the next steps) in   my calculator  .

This   step    starts    with    the Spice:   each   material   (not   necessarily   unique)   with   a 𝐶𝑜𝑜𝑘𝐸𝑛𝑒𝑚𝑦 tag   adds   its (which   is   a   property   of   some   materials)   value   to 𝐶𝑜𝑜𝑘𝐸𝑛𝑒𝑚𝑦 𝑆𝑝𝑖𝑐𝑒𝐵𝑜𝑜𝑠𝑡𝐸𝑓𝑓𝑒𝑐𝑡𝑖𝑣𝑒𝑇𝑖𝑚𝑒 a    bonus    time    variable    which    will    be    used    later.    This    spreadsheet    has    the    cook    T ags    of    each material as well as their (called Spice Effect time increase in the sheet). 𝑆𝑝𝑖𝑐𝑒𝐵𝑜𝑜𝑠𝑡𝐸𝑓𝑓𝑒𝑐𝑡𝑖𝑣𝑒𝑇𝑖𝑚𝑒

If    two   materials    of    the    cooking   material   list   have   different   effects,   the   effect   is   set   to   None (unless   it's   an   Elixir,   in   which   case   the   meal   result   becomes   the   failed   meal,   e.g.   Dubious   Food).   If no   material    in    the    cooking    material    list   has   an   effect   (unless   it's   an   Elixir,   in   which   case   the   meal result    becomes    once    again    Dubious    Food),    the    game    goes    to    the    next   step.   Else   (e.g.   the   meal has one effect):

- -The effect potency and effect duration are initialized at 0
- -The bonus time variable talked about earlier is added to the effect duration
- -Each   material   in   the   cooking   material   list   adds   30   seconds   to   the   effect   duration,   and   if   its effect matches the effect of the meal, it does two things:
- -It   adds   its (the   potency   of   the   material,   Effect   potency   in   the   main 𝐶𝑢𝑟𝑒𝐸𝑓𝑓𝑒𝑐𝑡𝐿𝑒𝑣𝑒𝑙 spreadsheet) to the effect potency
- -It adds the (a property of the effect) to the effect time, if it exists 𝐵𝑎𝑠𝑒𝑇𝑖𝑚𝑒
- -The    effect    level    becomes (of    the    effect).    The    effect    spreadsheet 𝐸𝑓𝑓𝑒𝑐𝑡𝑃𝑜𝑡𝑒𝑛𝑐𝑦   *    𝑅𝑎𝑡𝑒 linked    above    also    has    equivalences   between   the   effect   potency   and   the   effect   level   (code wise    they    are    the    same    variable,    but    I    decided    to    separate    them    to    make    it    easier    for everyone).   If   the   effect   level   is   bigger   than   the of   the   effect,   it   becomes   the of 𝑀𝑎𝑥𝐿𝑣 𝑀𝑎𝑥𝐿𝑣 the effect.

If   the   resulting   recipe   is   a   Fairy   T onic,   the   effect   is   set   to   None,   and   the   effect   duration   and level are set to 0.

## Getting the health recovery

This    step    generates    the    basic    health    recovery    amount,    in    health    points    (a    Heart    is    four health   points).   The   health   recovery   is   initialized   to   0,   and   each   material   of   the   cooking   material   list adds   its (property   of   the   material,   Health   recovered   in   the   main   spreadsheet  )   to   it 𝐻𝑖𝑡𝑃𝑜𝑖𝑛𝑡𝑅𝑒𝑐𝑜𝑣𝑒𝑟 (if    the exists).    Then,    the    game    multiplies    the    health    recovery    with    the    health 𝐻𝑖𝑡𝑃𝑜𝑖𝑛𝑡𝑅𝑒𝑐𝑜𝑣𝑒𝑟 recovery rate, which is 2, and moves on to the next step.

In    case    of    a    failed    meal    (Dubious    Food    or    Rock-Hard    Food),    its    effect    is    set   to   None,   its effect    time    and    level    as    well    as    its critical    rate    are    set    to 0,   its   selling   price   is   set   to   2, and   if   it's Rock-Hard   Food   its   health   recovery   is   set   to   ¼   Heart,   if   it's   the   Dubious   Food   its   health   recovery   is set to 1 Heart. Then, skip to the Conclusion step .

## Monster Extract effects

This   step   covers   the   effects   a   Monster   Extract   can   have   on   a   meal,   if   it's   present   in   it.   This step   is   skipped   if   the   recipe   result   is   Dubious   Food   or   Rock-Hard   Food.   It   only   happens   once   per meal,    even    if    there    are    multiple    Monster    Extracts    in    the    meal.    If    there    is    a    Monster    Extract    in    a meal,   the   meal   cannot   receive   a   Critical   hit   ( skip   to   the   Non-CookEnemy   Spice   section ).   Unlike Criticals,    Monster    Extracts    can    have    a    negative    effect    on    your    meals,    so    think    well   before   using one. Now, let's move on to the actual effects of the Monster Extract on the meal.

- -First    of    all,    if    the   meal    has    an    effect    and    an    effect    duration,    the    effect    duration    is   sets   to either    1 minute,    10    minutes    or    30    minutes,    randomly    (each    has    a    33.3%    chance    of happening)
- -If    the    meal    has    a    null    health    recovery    and    has    an    effect    OR    is    Hearty,    its    effect    level    is either    set    to    the of    the    effect,    either    gets    the 2 (see   Getting   the   effect   and   its 𝑀𝑖𝑛𝐿𝑣 𝑆𝑆𝐴𝑉 stats   section) of the effect added to it (each has a 50% chance of happening)
- -Else,    if    the    meal   has    a    null    health    recovery    and    has    no    effect,    it    gets    3    hearts    of    health recovery 3
- -Else,   if   the   meal   has   an   effect   and   a   non-zero   health   recovery,   one   of   the   following   happens (each has a 25% chance of happening):
- -Health recovery is set to 1 health point (¼ heart)
- -Health recovery is added 3 Hearts
- -Effect level gets set to 1
- -Effect level gets the of the effect added to it 𝑆𝑆𝐴𝑉

2 Unlike level Critical hits (as we'll see in a minute), Monster Extract positive level effect doesn't always get an additional level on your effect. In the case of the effect being inferior to 1.0 prior to the Monster Extract effect, it will not be enough to reach level 2 even with that boost, and will be brung back to 1 after some steps.

3 This case (null health recovery and no effect) isn't possible in the game, as there is no meal that has no effect and also has no health recovery at all.

- -Else,   if   the   meal   has   no   effect   and   a   non-zero   health   recovery,   health   recovery   is   either   set to 1 health point (¼ heart) or is added 3 Hearts (each has a 50% chance of happening)

## Getting the critical rate

This   step   generates   the   chances   your   meal   gets   a   critical   hit,   if   critical   hits   are   not   inhibited (more   on   that   later).   When   a   critical   hit   happens,   the   music   will   be   a   bit   more   joyful   and   Link   will   be happier    about    the    result.    The    meal    will    get    a    boost    in    one    of    the    three    main    statistics    (effect duration, effect level, and health recovery), depending on the conditions, more on that later.

The    critical    rate    is    initialized    at    0,    and    the    highest (property    of    the 𝑆𝑢𝑝𝑒𝑟𝑆𝑢𝑐𝑐𝑒𝑠𝑠𝑅𝑎𝑡𝑒 material,   Added   critical   chance   in   the   main   spreadsheet  )   of   all   materials   (if   it   exists)   is   added.   Then the   game   adds where is    the    amount   of   unique 5   *    𝑈𝑛𝑖𝑞𝑢𝑒𝑀𝑎𝑡𝑒𝑟𝑖𝑎𝑙𝑠𝑁𝑢𝑚 𝑈𝑛𝑖𝑞𝑢𝑒𝑀𝑎𝑡𝑒𝑟𝑖𝑎𝑙𝑠𝑁𝑢𝑚 materials   in    your    materials    list.    Finally,    the   critical   rate   is   divided   by   100   (in   order   to   be   an   actual rate).

## Critical hit effects

This   step    covers    the    effect    a    Critical    hit    has    on    a   meal.   As   a   reminder,   a   Critical   hit   can't happen   if    there    is    a   Monster   Extract   in   the   meal   materials.   That   step   is   also   skipped   if   the   recipe result    is    Dubious    Food    or    Rock-Hard    Food.    There    are    three    types    of    Critical    effects:    The    effect duration   gets   5   additional   minutes,   the   effect   gets   SSAV   added   to   its   level,   or   the   health   recovery   is added   3   Hearts.   If   a   Critical   hit   is   rolled   (e.g.   if   a   random   number   between   0   and   1   is   smaller   than Critical rate), the following happen:

- -If the effect level is lower than 1.0, set it to 1.0
- -If the meal has no effect, a health Critical hit is rolled
- -Else, if the effect is Hearty, it gets one more Extra Heart (level Critical hit, is 4) 𝑆𝑆𝐴𝑉
- -Else,   if    the    effect   is   Stamina   Recovery   or   Extra   Stamina,   the   game   checks   whether   or   not the effect level has reached the of the effect 𝑀𝑎𝑥𝐿𝑣
- -If the has been reached, a health Critical hit is rolled 𝑀𝑎𝑥𝐿𝑣
- -Else,   a   random   Critical   hit   is   rolled   between   health   and   level   (in   the   case   of   a   level Critical hit, adds 2 Stamina Segments / Extra Stamina Segments, is 2) 𝑆𝑆𝐴𝑉
- -Else,   if    the    effect    level    has    reached   the of   the   effect,   the   game   checks   whether   or 𝑀𝑎𝑥𝐿𝑣 not the health recovery has reached its (160, or 40 Hearts) 𝑀𝑎𝑥𝐿𝑣
- -If the of the health recovery has been reached, a time Critical hit is rolled 4 𝑀𝑎𝑥𝐿𝑣
- -Else, a random Critical hit is rolled between time and health
- -Else, the game checks whether or not the health recovery has reached max health
- -If    the has   been    reached,    a    random    Critical    hit    is    rolled    between    level    and 𝑀𝑎𝑥𝐿𝑣 time
- -Else, a random Critical hit is rolled between level, health and time

## NonSpice 𝐶𝑜𝑜𝑘𝐸𝑛𝑒𝑚𝑦

This   step   handles   the   eventual   health   recovery   and   effect   time   boosts   some   materials   can give   to   the   meal,   after   Monster   Extract   and   Critical   hits   are   processed.   For   each unique material   in the   cooking    materials    list,    the    game   checks   if   it   has   the Tag.   If   it   doesn't,   it   adds   the 𝐶𝑜𝑜𝑘𝐸𝑛𝑒𝑚𝑦 material's (Spice   Health   recovery   increase   in   the   main   spreadsheet  )   to 𝑆𝑝𝑖𝑐𝑒𝐵𝑜𝑜𝑠𝑡𝐻𝑖𝑡𝑃𝑜𝑖𝑛𝑡𝑅𝑒𝑐𝑜𝑣𝑒𝑟

4 A    Gloom    Recovery    meal    would    get    at    least    50%    chance    of    getting    a    time    Critical    hit,    despite    being    a duration-less meal. That means you can get a Critical hit and not get any positive effect from it.

the    Health    recovery,    and (Spice    Effect    time    increase    in the    main 𝑆𝑝𝑖𝑐𝑒𝐵𝑜𝑜𝑠𝑡𝐸𝑓𝑓𝑒𝑐𝑡𝑖𝑣𝑒𝑇𝑖𝑚𝑒 spreadsheet  )    to    the    effect    duration    (if    it    exists).    The    fact    that   the Spice   is   separated 𝐶𝑜𝑜𝑘𝐸𝑛𝑒𝑚𝑦 from   the   nonSpice   makes   it   so   that   if   a   Monster   Extract   sets   the   time   to   1:00   or   10:00 𝐶𝑜𝑜𝑘𝐸𝑛𝑒𝑚𝑦 and/or   the   health   recovery   to   ¼   Heart,   the Spice   will   be   overridden   by   it,   while   the   non𝐶𝑜𝑜𝑘𝐸𝑛𝑒𝑚𝑦 Spice will be added on top of the 1:00 / 10:00 time and/or ¼ Heart recovery. 𝐶𝑜𝑜𝑘𝐸𝑛𝑒𝑚𝑦

## Meal bonuses

This   step    covers   the   eventual   health   recovery   change   the   meal   can   receive   depending   on the   recipe   result.   This   step   is   very   straightforward,   the   game   adds   the (Bonus   health 𝐵𝑜𝑛𝑢𝑠𝐻𝑒𝑎𝑟𝑡 in the   main spreadsheet  ) of the recipe (if it exists)   to the meal.

## Adjusting values

This   final   step   covers   the   clamping   of   effect   time,   effect   level   and   health   recovery   between minimum and maximum values.

- -If the effect time (if it exists) &gt; 1800, it's set to 1800 (can't be above 30:00)
- -If    the   health   recovery   is   &gt;   120   or   if   the   effect   is   Hearty,   it's   set   to   160   (any   Hearty   meal   or with more than 30 Hearts of recovery gets Full Recovery)
- -If    the   meal    has    no    effect    and   has   a   null   health   recovery,   its   health   recovery   gets   set   to   ¼ Heart
- -If   the   effect   level   (if   it   exists)   &gt; for   the   effect,   it's   set   to   the (the   level   can't   be 𝑀𝑎𝑥𝐿𝑣 𝑀𝑎𝑥𝐿𝑣 higher than the max)
- -If the effect level (if it exists) is between 0 (excluded) and 1, it's set to 1
- -If   the   effect   is   Extra   Heart   or   Gloom   Recovery,   the   effect   level   gets   rounded   to   the   nearest 4, and is set to 4 if it's inferior to 4 (so that only full Extra / Ungloomed Hearts are allowed)
- -The effect level is rounded down

Dubious    Food's    health    recovery    is    set    to    1    Heart    and    its    effect    is    set    to    None,    and Rock-Hard Food's health recovery is set to ¼ Heart and its effect is set to None.

## Getting the selling price

Before   moving   on   to   the   conclusion,   let's   calculate   the   selling   price   of   the   meal.   The   selling price   is   initialized   to   0,   then   each   material   in   the   cooking   materials   list   adds   its   selling   price   to   the selling    price    of    the    meal,    unless    it    has    the Tag   (see    Cook    Low    Price    in    the    main 𝐶𝑜𝑜𝑘𝐿𝑜𝑤𝑃𝑟𝑖𝑐𝑒 spreadsheet  ).    In    this    case,    it    only    adds    1    to    the    selling    price    of    the    meal.    After    that,    the    game checks   the    amount   of   materials   (regardless   of   if   they're   unique)   and   multiplies   the   selling   price   of the    meal    with    1.2    if    there's    one    material,    1.3    if    there    are    two    materials,    1.4    if    there    are    three materials,   1.6   if   there   are   four   materials,   and   1.8   if   there   are   five   materials.   Then,   it   rounds   the   final selling    price    down.    If    the    final    selling    price    of    the   meal   is   lower   than   3,   it's   set   to   3.   Finally,   if   the recipe   result   is   a   Fairy   T onic,   a   Dubious   Food   or   a   Rock-Hard   Food,   the   final   selling   price   is   set   to 2.

## Conclusion

If you came here because you skipped to the end after a failed meal, you probably messed up somewhere when choosing your materials, but hopefully you still learned some stuff. Otherwise, voilà! The game finished calculating your beautiful meal's statistics and outputs it to you, all pretty and clean. This document ends there! Thanks for reading. If you don't understand something, or think there is an error somewhere, please let me know in Discord (my username is echocolat)!

## Credits

- -Spreadsheet and document made by Echocolat
- -CookingMgr code retrieved and deciphered by dt12345
- -TotK Cooking Calculator by Echocolat
- -Base code used by the calculator by KingFoo
- -Online part of the calculator by Glitchtest
- -Additional research by Echocolat, dt12345 and Doge229
- -Additional testing by Doge229