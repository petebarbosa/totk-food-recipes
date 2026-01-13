# Change Log

This document tracks significant changes made to the codebase to provide context for future development.

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
