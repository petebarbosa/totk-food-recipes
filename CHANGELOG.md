# Change Log

This document tracks significant changes made to the codebase to provide context for future development.

---

## [2026-01-14] - Implement Tag-Based Recipe Matching System

**Type:** Feature / Bug Fix

**Summary:** Implemented a comprehensive tag-based recipe matching system that correctly filters recipes based on whether ALL pot ingredients can be accommodated. Added missing Fish/Seafood/Critter ingredients.

**Why:** The previous system used direct category matching which failed for:
- Sub-categories (Apple vs Fruit, Porgy vs Fish, Pumpkin vs Plant)
- Missing ingredient types (Fish, Crabs, Snails, Critters)
- Filtering logic (showed recipes even when some ingredients couldn't be used)

**Key Changes:**
- Ingredients now have `cook_tags` array for flexible matching
- Apple has tags `["Fruit", "Apple"]` so it matches both Simmered Fruit and Apple Pie
- Recipe matching filters out recipes that can't accommodate ALL pot ingredients
- Added 35 new Fish/Seafood/Critter ingredients (total now 237 ingredients)

**Tag Hierarchy:**
- `Fruit` → with sub-tags like `Apple`
- `Plant` → with sub-tags like `Carrot`, `Pumpkin`, `Hearty Radish`
- `Meat` → with sub-tags like `Prime Meat`, `Gourmet Meat`
- `Fish` → with sub-tags like `Porgy`, `Trout`, `Crab`, `Snail`
- `Mushroom`, `Nut`, `Spice`, `Enemy`, `Ore`, `Insect`, `Fairy`, `Special`

**Files Changed:**
- `db/migrate/20260114143255_add_cook_tags_to_ingredients.rb` - New migration
- `db/csv/ingredients.csv` - Added Cook_Tags column and 35 new ingredients
- `db/seeds.rb` - Parse cook_tags from CSV
- `app/models/ingredient.rb` - Added `has_cook_tag?` and `matches_requirement?` methods
- `app/models/recipe_requirement.rb` - Updated `matches?` for tag-based matching
- `app/services/recipe_matcher.rb` - Updated accommodation filtering to use tags
- `test/fixtures/ingredients.yml` - Added cook_tags to fixtures, added fish fixtures
- `test/fixtures/recipe_requirements.yml` - Updated comments for tag-based matching
- `test/models/ingredient_test.rb` - Added tag matching tests
- `test/services/recipe_matcher_test.rb` - Updated tests for tag-based matching

**Related:** Aligns recipe filtering with actual TotK cooking mechanics from tears_cooking_guide.md

---

## [2026-01-14] - Add Render deployment support for ephemeral storage

**Type:** Config

**Summary:** Modified docker-entrypoint to auto-seed database on empty DB, added render.yaml for Render Blueprint deployments

**Why:** Enable deployment to Render's free tier which has ephemeral storage - database is wiped on each deploy, requiring automatic seeding

**Files Changed:**
- `bin/docker-entrypoint` - Added conditional db:seed when database is empty
- `render.yaml` - New Render Blueprint configuration file

**Related:** N/A

---

## [2026-01-13] - Add recipe images to Cooking Preview and Matching Recipes

**Type:** Feature

**Summary:** Added recipe images to the Cooking Preview section and Matching Recipes cards for visual dish identification

**Why:** Improve visual recognition of recipes by showing actual dish images from the game alongside calculated stats

**Files Changed:**
- `app/assets/images/recipes/` - Added 229 recipe images from TotK wiki
- `app/helpers/application_helper.rb` - Added `recipe_image_path` and `recipe_image_tag` helpers with 🥘 emoji fallback
- `app/views/cooking/_result.html.erb` - Added recipe image to Cooking Preview section
- `app/views/recipes/_card.html.erb` - Added recipe thumbnails to Matching Recipes cards
- `test/helpers/application_helper_test.rb` - Added tests for recipe image helper methods

**Related:** [2026-01-13] - Add ingredient images to Cooking Pot and search results

---

## [2026-01-13] - Add ingredient images to Cooking Pot and search results

**Type:** Feature

**Summary:** Replaced emoji-based ingredient display with actual game images in the Cooking Pot UI and ingredient search results

**Why:** Improve visual fidelity and user experience by showing recognizable ingredient images from the game

**Files Changed:**
- `app/assets/images/ingredients/` - Added 202 ingredient images from TotK wiki
- `app/helpers/application_helper.rb` - Added `ingredient_image_path` and `ingredient_image_tag` helpers with emoji fallback
- `app/views/cooking/_slot.html.erb` - Updated to use ingredient images instead of category emojis
- `app/views/ingredients/_ingredient.html.erb` - Added ingredient thumbnails to search results
- `test/helpers/application_helper_test.rb` - Added tests for new helper methods

**Related:** N/A

---

## [2026-01-13] - Enable smart ingredient search with word-start matching

**Type:** Feature

**Summary:** Improved ingredient search to use word-start matching for all queries (matches if any word in the name starts with the query)

**Why:** Better UX - typing "G" shows "Goat Butter" and "Golden Apple" (words starting with G) but not "Light Dragon's Claw" (G is mid-word in "Dragon's"). Typing "apple" shows "Apple" and "Golden Apple" but not "Sapphire". Typing "ca" shows "Cane Sugar" but not "Brightcap"

**Files Changed:**
- `app/models/ingredient.rb` - Updated `search_by_name` scope with conditional matching logic
- `test/models/ingredient_test.rb` - Updated and added tests for new search behavior
- `test/fixtures/ingredients.yml` - Added fixture for testing mid-word exclusion

**Related:** N/A

---

## [2026-01-13] - Comprehensive ingredient database update

**Type:** Data

**Summary:** Updated ingredients.csv with 202 ingredients from official TotK materials list including:
- 15 fruits (Apple, Dazzlefruit, Fire Fruit, Golden Apple, Hydromelon, etc.)
- 17 seasonings/dairy/grains (Cane Sugar, Goat Butter, Bird Egg, Hylian Rice, etc.)
- 6 meats (Raw Meat variants, Raw Bird variants)
- 115 monster parts (Bokoblin, Moblin, Lizalfos, Lynel, Dragon parts, etc.)
- 11 minerals (Amber, Diamond, Ruby, Sapphire, etc.)
- 16 herbs (Armoranth, Blue Nightshade, Cool Safflina, Sundelion, etc.)
- 15 mushrooms (Hearty Truffle, Chillshroom, Ironshroom, etc.)
- 6 vegetables (Big Hearty Radish, Endura Carrot, Fortified Pumpkin, etc.)
- Special items (Fairy, Star Fragment, Dark Clump)

**Why:** Expand the ingredient database to include all cookable materials from the game for comprehensive recipe matching

**Files Changed:**
- `db/csv/ingredients.csv` - Complete rewrite with 202 ingredients (previously had 53)

**Related:** N/A

---

## [2026-01-13] - Fix remove ingredient/clear pot/select recipe not updating frontend

**Type:** Bug Fix

**Summary:** Fixed two issues preventing cooking pot actions from updating the UI:
1. Changed button_to forms to JavaScript fetch with explicit Turbo Stream handling
2. Changed turbo_stream.replace to turbo_stream.update to preserve turbo-frame wrappers

**Why:** 
- The button_to forms inside turbo-frames weren't processing Turbo Stream responses correctly
- Using `turbo_stream.replace` removed the turbo-frame wrapper elements, causing subsequent operations to fail (no target element found)

**Files Changed:**
- `app/controllers/cooking_controller.rb` - Changed turbo_stream.replace to turbo_stream.update in render_cooking_updates
- `app/javascript/controllers/cooking_controller.js` - Added removeIngredient, clearPot, and selectRecipe methods with fetch and Turbo.renderStreamMessage
- `app/views/cooking/_slot.html.erb` - Replaced button_to with button using Stimulus action
- `app/views/home/index.html.erb` - Replaced button_to with button using Stimulus action
- `app/views/recipes/_card.html.erb` - Replaced button_to with button using Stimulus action

**Related:** [2026-01-13] - Fix ingredient click not adding to cooking pot

---

## [2026-01-13] - Hide cook button for non-pot recipes & remove redundant effect variants

### Changed
- Hide "Cook this recipe" button for non-pot recipes (fire/cold-cooked items)
  - These include: Baked, Roasted, Toasted, Toasty, Frozen, Icy, Seared, Charred, Campfire, Hard-boiled, Warm, Blackened, Blueshell items
  - Plus specific items: Sneaky River Escargot, Bright Mushroom Skewer

### Removed
- Removed 19 redundant effect-variant recipes from the database
  - Effect variants like "Energizing Steamed Fish" are redundant since the effect is already visible when adding ingredients
  - Removed: Sunny Mushroom Skewer, Enduring Fruit and Mushroom Mix, Energizing Steamed Fish/Fruit/Meat/Mushrooms, Fireproof Fish and Mushroom Skewer/Fried Wild Greens/Glazed Meat/Mushroom/Seafood/Veggies/Meat and Mushroom Skewer/Omelet, Hasty Copious Fried Wild Greens/Simmered Fruit, Mighty Fish Skewer/Meat Skewer/Simmered Fruit

---

## [2026-01-13] - Fix ingredient click not adding to cooking pot

**Type:** Bug Fix

**Summary:** Changed ingredient selection from button_to form to JavaScript fetch with explicit Turbo Stream handling

**Why:** The button_to form inside the turbo-frame wasn't processing Turbo Stream responses correctly

**Files Changed:**
- `app/views/ingredients/_ingredient.html.erb` - Replaced button_to with clickable div using Stimulus action
- `app/javascript/controllers/search_controller.js` - Added addIngredient method with fetch POST and Turbo.renderStreamMessage

**Related:** N/A

---

## [2026-01-13] - Fix ingredient search not updating on subsequent keystrokes

**Type:** Bug Fix

**Summary:** Changed turbo_stream.replace to turbo_stream.update to preserve the turbo-frame wrapper during search

**Why:** Using replace removed the turbo-frame element from DOM after first search, breaking subsequent searches

**Files Changed:**
- `app/views/ingredients/search.turbo_stream.erb` - Changed replace to update
- `app/views/home/index.html.erb` - Added `block` class to turbo-frame for proper positioning

**Related:** N/A

---

## [2026-01-13] - Fix ingredient search initial letter bug

**Type:** Bug Fix

**Summary:** Fixed issue where typing initial letter showed all ingredients containing that letter instead of matching from start

**Why:** Improve search UX by ensuring results match user expectations (prefix matching)

**Files Changed:**
- `app/models/ingredient.rb` - Updated search scope query
- `test/models/ingredient_test.rb` - Updated test for search behavior

**Related:** N/A

---

## [2026-01-13] - Add update changelog command

**Type:** Documentation

**Summary:** Added reminder to update changelog in behavioral guidelines

**Why:** Ensure changelog stays up to date with future changes

**Files Changed:**
- `AGENTS.md` - Added changelog update guideline

**Related:** N/A

---

## [2026-01-13] - Add agents and readme documentation

**Type:** Documentation

**Summary:** Added comprehensive AGENTS.md and improved README.md with project setup, conventions, and guidelines

**Why:** Provide thorough documentation for developers and AI assistants to understand the project

**Files Changed:**
- `AGENTS.md` - New file with project overview, structure, conventions, and AI guidelines
- `README.md` - Enhanced with detailed setup instructions and project information

**Related:** N/A

---

## [2026-01-13] - Build core application

**Type:** Feature

**Summary:** Implemented the TotK Recipe Calculator with ingredient search, cooking pot, recipe matching, and stat calculation

**Why:** Core feature implementation for the cooking simulation app

**Files Changed:**
- `app/controllers/` - Added cooking, home, ingredients, and recipes controllers
- `app/models/` - Added Ingredient, Recipe, and RecipeRequirement models
- `app/services/` - Added CookingCalculator and RecipeMatcher services
- `app/views/` - Added all view templates for cooking pot, ingredients, and recipes
- `app/javascript/controllers/` - Added Stimulus controllers for cooking and search
- `app/assets/tailwind/application.css` - Custom Tailwind component styles
- `db/migrate/` - Database migrations for models
- `db/csv/` - Seed data for ingredients and recipes
- `test/` - Comprehensive tests for models, integration, and system
- `.cursor/` - AI assistant rules and templates

**Related:** N/A

---

## [2026-01-13] - Initial commit

**Type:** Config

**Summary:** Rails 8.1.2 application scaffolding with Kamal deployment configuration

**Why:** Project initialization with modern Rails stack

**Files Changed:**
- `.github/workflows/ci.yml` - CI pipeline configuration
- `.kamal/` - Kamal deployment hooks and secrets
- `Dockerfile` - Container configuration
- `Gemfile` - Ruby dependencies
- `config/` - Rails configuration files
- Standard Rails boilerplate files

**Related:** N/A
