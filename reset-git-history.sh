#!/bin/bash

# Script to delete all commit history and start fresh
# WARNING: This will delete all commit history on remote!

echo "⚠️  WARNING: This script will delete ALL commit history!"
echo "📋 Current branch: $(git branch --show-current)"
echo "📍 Current remote: $(git remote get-url origin)"
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Cancelled"
    exit 1
fi

echo ""
echo "🗑️  Deleting all commit history..."

# Checkout to main/master branch
BRANCH=$(git branch --show-current)
if [ -z "$BRANCH" ]; then
    BRANCH="main"
fi

# Create orphan branch (no history)
echo "📦 Creating orphan branch..."
git checkout --orphan temp_branch

# Add all files
echo "📝 Adding all files..."
git add .

# Create initial commit
echo "💾 Creating initial commit..."
git commit -m "Initial commit - fresh start"

# Delete old branch
echo "🗑️  Deleting old branch..."
git branch -D $BRANCH

# Rename current branch to main
echo "🏷️  Renaming branch to $BRANCH..."
git branch -m $BRANCH

# Force push to remote (delete history on remote)
echo "🚀 Force pushing to remote (this will delete all history on remote)..."
git push -f origin $BRANCH

echo ""
echo "✅ Done! All commit history has been deleted."
echo "📊 New commit count: $(git rev-list --count HEAD)"
echo ""
echo "⚠️  Note: If you're working with a team, they need to run:"
echo "   git fetch origin"
echo "   git reset --hard origin/$BRANCH"

