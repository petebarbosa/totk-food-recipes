# TotK Recipe Calculator

A web application that simulates the cooking mechanic from **The Legend of Zelda: Tears of the Kingdom**. Plan your meals before you cook them in-game!

![Ruby](https://img.shields.io/badge/Ruby-4.0.0-red?logo=ruby)
![Rails](https://img.shields.io/badge/Rails-8.1.2-red?logo=rubyonrails)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-v4-blue?logo=tailwindcss)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- **Ingredient Search** - Quickly find ingredients by name with instant search
- **Virtual Cooking Pot** - Add up to 5 ingredients just like in the game
- **Recipe Matching** - See which recipes match your selected ingredients with percentage indicators
- **Dish Calculator** - Preview your dish's stats before cooking:
  - Hearts restored
  - Effect type and level (Attack Up, Defense Up, Cold Resistance, etc.)
  - Effect duration
  - Critical cook chance
- **Real-time Updates** - Instant UI updates powered by Hotwire/Turbo

## How It Works

The calculator faithfully recreates the TotK cooking system:

### Cooking Mechanics

1. **Add Ingredients** - Search and add up to 5 ingredients to your pot
2. **See Matches** - View recipes that match your ingredient combination
3. **Preview Results** - See calculated dish stats before cooking
4. **Experiment** - Try different combinations to optimize your meals

### Effect System

- **Single Effect Rule**: All effect ingredients must share the same effect type, or effects cancel out
- **Effect Levels**: More effect points = higher effect level (up to Level 3 for most effects)
- **Duration**: Each ingredient adds to the buff duration (seasonings add more!)

### Critical Cooking

- **10% base chance** for a critical cook bonus
- **100% guaranteed** with Golden Apple or Star Fragment
- Bonuses include: +3 Hearts, +1 Effect Level, +5:00 Duration, and more!

## Getting Started

### Prerequisites

- Ruby 4.0.0
- Bundler

### Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/totk-food-recipes.git
cd totk-food-recipes

# Install dependencies and setup database
bin/setup
```

The setup script will:
1. Install all gem dependencies
2. Create and seed the database with ingredients and recipes
3. Start the development server

### Manual Setup

```bash
# Install dependencies
bundle install

# Setup database
bin/rails db:prepare
bin/rails db:seed

# Start the server
bin/dev
```

Visit `http://localhost:3000` to start cooking!

## Usage Guide

### Searching for Ingredients

1. Type in the search box at the top left
2. Results appear instantly as you type
3. Click an ingredient to add it to your pot

### Managing Your Pot

- **Add**: Click ingredients from search results
- **Remove**: Click the X on any ingredient in the pot
- **Clear**: Click "Clear" to empty the pot completely

### Reading Recipe Matches

Recipes show match percentages:
- **100%** - You have all required ingredients
- **50-99%** - Partially matched, missing some ingredients
- **< 50%** - Few matches, consider different ingredients

### Understanding Dish Stats

| Stat | Description |
|------|-------------|
| **Hearts** | Red hearts restored when eating |
| **Effect** | Buff type (e.g., "Attack Up Lv. 2") |
| **Duration** | How long the buff lasts |
| **Critical %** | Chance for bonus effects |

## Project Structure

```
totk-food-recipes/
├── app/
│   ├── controllers/     # Request handling
│   ├── models/          # Data models (Ingredient, Recipe)
│   ├── services/        # Business logic (Calculator, Matcher)
│   └── views/           # UI templates
├── db/
│   └── csv/             # Ingredient & recipe data
├── lib/
│   └── cooking_rules.md # Game mechanic documentation
└── test/                # Test suite
```

## Running Tests

```bash
# All tests
bin/rails test

# System tests (browser-based)
bin/rails test:system

# With coverage
bin/rails test -v
```

## Development

### Code Quality

```bash
# Lint Ruby code
bin/rubocop

# Security scan
bin/brakeman

# Dependency audit
bin/bundler-audit

# Run all CI checks
bin/ci
```

### Adding New Data

**New Ingredient:**
1. Add to `db/csv/ingredients.csv`
2. Run `bin/rails db:seed`

**New Recipe:**
1. Add to `db/csv/recipes.csv`
2. Format requirements as: `[Category:Fruit];[Specific:Apple]`
3. Run `bin/rails db:seed`

## Game Reference

This calculator implements the cooking rules from Tears of the Kingdom. For detailed mechanics, see:
- [`lib/cooking_rules.md`](lib/cooking_rules.md) - Complete algorithm specification

### Effect Thresholds

| Effect | Level 1 | Level 2 | Level 3 |
|--------|---------|---------|---------|
| Attack/Defense/Speed Up | 1-4 pts | 5-6 pts | 7+ pts |
| Resistances (Cold/Heat/Shock) | 1-5 pts | 6+ pts | N/A |
| Stealth Up | 1-5 pts | 6-8 pts | 9+ pts |

### Ingredient Categories

- Fruit
- Vegetable
- Mushroom
- Meat
- Fish
- Herb
- Critter
- Monster Part
- Mineral
- Seasoning

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Run tests and linting (`bin/ci`)
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- Nintendo for creating the amazing cooking system in Tears of the Kingdom
- The Zelda community for documenting the game mechanics
- [Hotwire](https://hotwired.dev/) for the reactive Rails experience
