#!/bin/bash

# Git Add, Commit, and Push Script
# Usage: ./git-push.sh "Your commit message"

# Check if commit message is provided
if [ $# -eq 0 ]; then
    echo "Error: No commit message provided"
    echo "Usage: $0 \"Your commit message\""
    echo "Example: $0 \"Add Flask application with info display\""
    exit 1
fi

# Get the commit message from the first parameter
COMMIT_MESSAGE="$1"

echo "🔄 Starting git operations..."
echo "📝 Commit message: $COMMIT_MESSAGE"
echo ""

# Add all files to staging area
echo "📁 Adding all files to staging area..."
git add .

# Check if there are any changes to commit
if git diff --staged --quiet; then
    echo "⚠️  No changes detected. Nothing to commit."
    exit 0
fi

# Show what will be committed
echo "📋 Files to be committed:"
git diff --staged --name-only

# Commit with the provided message
echo ""
echo "💾 Committing changes..."
git commit -m "$COMMIT_MESSAGE"

# Check if commit was successful
if [ $? -ne 0 ]; then
    echo "❌ Commit failed. Please check for errors."
    exit 1
fi

# Push to remote repository
echo ""
echo "🚀 Pushing to remote repository..."
git push origin main

# Check if push was successful
if [ $? -eq 0 ]; then
    echo "✅ Successfully pushed to remote repository!"
    echo "🌐 Repository: https://github.com/GeorgeFalkovich/ArgoApp"
else
    echo "❌ Push failed. Please check your network connection and repository access."
    echo ""
    echo "Common solutions:"
    echo "1. Check if you're authenticated with GitHub"
    echo "2. Verify repository permissions"
    echo "3. If this is the first push, try: git push -u origin main"
fi