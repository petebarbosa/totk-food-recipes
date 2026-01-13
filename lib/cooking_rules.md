# Tears of the Kingdom (TotK) Cooking Algorithm Specification

## 1. Overview
This document defines the logic required to simulate the cooking mechanic in *The Legend of Zelda: Tears of the Kingdom*. The system takes a set of input ingredients (1 to 5 items) and outputs a resulting **Dish Name**, **Heart Recovery**, **Status Effect**, and **Duration**.

## 2. Data Structures

### 2.1 Input Object (Ingredient)
Each ingredient used in the cooking pot must possess the following attributes:
* **Name** : Unique identifier (e.g., "Apple").
* **Category** : The classification used for generic recipes.
    * *Values:* `Fruit`, `Vegetable`, `Mushroom`, `Meat`, `Fish`, `Herb`, `Critter`, `Monster Part`, `Mineral`, `Seasoning`.
* **Hearts_Raw** : Base healing value (1 Heart = 1.0).
* **Effect_Type** : The status effect provided.
    * *Values:* `None`, `Spicy` (Cold Res), `Chilly` (Heat Res), `Electro` (Shock Res), `Energizing` (Stamina), `Enduring` (Extra Stamina), `Hearty` (Extra Hearts), `Mighty` (Attack), `Tough` (Defense), `Sneaky` (Stealth), `Bright` (Glow).
* **Effect_Points** : The potency contribution to the effect level.
* **Boost_Type** : Special flags.
    * *Values:* `None`, `Critical_Cook` (Golden Apple), `Duration_Up` (Oil/Eggs).

### 2.2 Recipe Template
Recipes are matching patterns with a hierarchy.
* **Name:** "Apple Pie"
* **Requirements:** List of conditions. A condition can be `[Specific:ItemName]` or `[Category:CategoryName]`.
* **Base_Hearts:** Bonus hearts added by the recipe mastery itself.

---

## 3. The Algorithm Logic

Once a base recipe (e.g., "Mushroom Skewer") is determined, calculate the final stats.

#### A. Health Calculation (Hearts)
Formula: `(Sum of Input Ingredients' Hearts_Raw * 2) + Recipe Base_Hearts`
* *Exception:* If the dish is `Dubious Food` or `Rock-Hard Food`, use fixed values.

#### B. Effect Type Determination
1.  Collect all `Effect_Type` values from inputs (excluding `None`).
2.  **Conflict Check:** If distinct effects exist (e.g., `Spicy` AND `Chilly`), they cancel out.
    * **Result:** Effect = `None`.
3.  **Dominant Effect:** If all effects are the same (or only one type exists), that is the Result Effect.

#### C. Effect Potency (Level)
Sum the `Effect_Points` of all ingredients. Compare to thresholds:

| Effect Type | Level 1 Threshold | Level 2 Threshold | Level 3 Threshold |
| :--- | :--- | :--- | :--- |
| Attack Up (Mighty) | 1 - 4 pts | 5 - 6 pts | 7+ pts |
| Defense Up (Tough) | 1 - 4 pts | 5 - 6 pts | 7+ pts |
| Speed Up (Hasty) | 1 - 4 pts | 5 - 6 pts | 7+ pts |
| Resistances (Cold/Heat/Shock) | 1 - 5 pts | 6+ pts | N/A (Max Lv 2) |
| Stealth Up | 1 - 5 pts | 6 - 8 pts | 9+ pts |

* *Note:* "Hearty" (Yellow Hearts) and "Enduring" (Yellow Stamina) do not use levels; they use raw summation of bonus values.

#### D. Duration Calculation (Buff Time)
Base Duration: `0:30` (30 seconds).

Add time per ingredient:
1.  **Standard Ingredients:** +30s each.
2.  **Seasonings/Eggs/Oil:** Look for `Duration_Up` flag (usually +60s or +90s).
3.  **Monster Parts (Elixirs Only):**
    * Tier 1 (e.g., Bokoblin Horn): +70s
    * Tier 2 (e.g., Lizalfos Talon): +110s
    * Tier 3 (e.g., Guts): +190s

### Phase 5: Critical Cook (RNG & Modifiers)
A "Critical Cook" boosts the final dish.

**Trigger Conditions:**
1.  **Guaranteed:** Input contains `Golden Apple` OR `Star Fragment`.
2.  **Guaranteed:** During a "Blood Moon" event (External App State).
3.  **Random:** 10% chance on standard cooks.

**Bonuses (Apply ONE randomly if Critical):**
* +3 Hearts
* +1 Effect Level (if valid)
* +5:00 Duration
* +1 Extra Yellow Heart (if Hearty dish)
* +2/5 Extra Stamina Wheel (if Energizing dish)
