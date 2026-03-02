-- PyDeck: Git & GitHub Complete Seed
-- Path, Topics, Subtopics, Concepts & Flashcards
-- Run in Supabase SQL Editor

-- ============================================================
-- PATH
-- ============================================================
INSERT INTO paths (id, name, description, icon, display_order) VALUES
  ('a1000000-0000-0000-0000-000000000007', 'Git & GitHub',
   'Learn version control with Git and collaborate on real projects using GitHub',
   'GitBranch', 7)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- TOPICS
-- ============================================================
INSERT INTO topics (id, path_id, name, icon, display_order) VALUES
  ('b7000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000007', 'Introduction to Git & GitHub', 'BookOpen', 1),
  ('b7000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000007', 'Git Basics', 'Terminal', 2),
  ('b7000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000007', 'Branching & Merging', 'GitMerge', 3),
  ('b7000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000007', 'Working with GitHub', 'Globe', 4),
  ('b7000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000007', 'Collaboration on GitHub', 'Users', 5),
  ('b7000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000007', 'Advanced Git', 'Zap', 6)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- SUBTOPICS
-- ============================================================

-- Topic 1: Introduction to Git & GitHub
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f1000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000001', 'What is Version Control?', 1),
  ('f1000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000001', 'What is Git?', 2),
  ('f1000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000001', 'What is GitHub?', 3),
  ('f1000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000001', 'Git vs GitHub', 4),
  ('f1000000-0000-0000-0000-000000000005', 'b7000000-0000-0000-0000-000000000001', 'Real-World Use Cases', 5)
ON CONFLICT (id) DO NOTHING;

-- Topic 2: Git Basics
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f2000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000002', 'Installing & Configuring Git', 1),
  ('f2000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000002', 'git init & git clone', 2),
  ('f2000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000002', 'git status & git add', 3),
  ('f2000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000002', 'git commit & git log', 4),
  ('f2000000-0000-0000-0000-000000000005', 'b7000000-0000-0000-0000-000000000002', 'git diff', 5)
ON CONFLICT (id) DO NOTHING;

-- Topic 3: Branching & Merging
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f3000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000003', 'What is a Branch?', 1),
  ('f3000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000003', 'Creating & Switching Branches', 2),
  ('f3000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000003', 'Merging Branches', 3),
  ('f3000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000003', 'Resolving Merge Conflicts', 4)
ON CONFLICT (id) DO NOTHING;

-- Topic 4: Working with GitHub
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f4000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000004', 'Creating a GitHub Repository', 1),
  ('f4000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000004', 'git remote, push & pull', 2),
  ('f4000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000004', 'README & .gitignore', 3),
  ('f4000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000004', 'Forking a Repository', 4)
ON CONFLICT (id) DO NOTHING;

-- Topic 5: Collaboration on GitHub
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f5000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000005', 'Pull Requests', 1),
  ('f5000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000005', 'Code Review', 2),
  ('f5000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000005', 'Issues & Project Boards', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 6: Advanced Git
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f6000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000006', 'Undoing Changes', 1),
  ('f6000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000006', 'git stash', 2),
  ('f6000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000006', 'Tags & Releases', 3),
  ('f6000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000006', 'Git Workflow Best Practices', 4)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- CONCEPTS
-- ============================================================

-- ---- SUBTOPIC: What is Version Control? ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000001',
 'f1000000-0000-0000-0000-000000000001',
 'What is Version Control?',
 '## What is Version Control?

Imagine you are writing a college project report. You keep saving it as:
- **report.docx**
- **report_final.docx**
- **report_final2.docx**
- **report_FINAL_USE_THIS.docx**

Sound familiar? This is a mess. You have no idea what changed between versions, and if you make a mistake, you cannot easily go back.

**Version Control** is a system that solves this problem. It:
- Tracks every change you make to your files
- Remembers who made the change and when
- Lets you go back to any previous version
- Lets multiple people work on the same project without overwriting each other

## Without Version Control — Real-World Problem

**Scenario:** You and your friend Rahul are building a website together. Both of you edit `index.html` at the same time. Rahul shares his file over WhatsApp. You copy-paste his changes manually. You accidentally delete a section. The site is broken and you do not know what was there before.

**With Version Control:** Every change is saved as a snapshot called a **commit**. You can see exactly what Rahul changed, merge both changes automatically, and instantly undo any mistake.

## Types of Version Control

| Type | How it works | Example |
|------|-------------|---------|
| Local | Versions saved only on your machine | Manual copies |
| Centralized | One central server everyone connects to | SVN |
| **Distributed** | Everyone has the full history locally | **Git** |

Git is **distributed** — even without internet, you have the complete history of your project on your own machine.',
 '# Without version control — manual chaos:
# report.docx
# report_v2.docx
# report_FINAL.docx
# report_FINAL_use_this_one.docx  ← which one is right?!

# With version control (Git) — automatic and clean:
git init                         # start tracking a project
git add report.docx              # tell git to watch this file
git commit -m "First draft"      # save snapshot #1
# ... you make changes ...
git commit -m "Added conclusion" # save snapshot #2
git log                          # see full history
git checkout <old-commit>        # go back to any version instantly',
 1);

-- ---- SUBTOPIC: What is Git? ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000002',
 'f1000000-0000-0000-0000-000000000002',
 'What is Git?',
 '## What is Git?

**Git** is a free, open-source **version control system** created by **Linus Torvalds** (the creator of Linux) in **2005**.

It runs **entirely on your local computer**. It has nothing to do with the internet. It just watches your project folder and takes a snapshot every time you tell it to.

## Simple Analogy

Think of Git like a **time machine** for your code:
- Every time you save a snapshot (called a **commit**), Git takes a photo of your entire project
- If you break something, you can go back to any previous photo instantly
- Git stores all these photos in a hidden folder called `.git` inside your project

## What Git Tracks

Git remembers:
- **What** files changed
- **Exactly which lines** changed inside each file
- **Who** made the change
- **When** the change happened
- **Why** (the message you write when committing)

## Key Properties

| Property | Meaning |
|----------|---------|
| **Local-first** | Works offline — no internet needed |
| **Fast** | Commit, branch, merge all happen in milliseconds |
| **Distributed** | Every developer has the full history |
| **Safe** | Data stored as checksums — nothing gets silently lost |

## Git is NOT GitHub

This is the biggest confusion for beginners. **Git is a tool you install on your computer. GitHub is a website.** They are completely separate. You can use Git without ever touching GitHub.',
 '# Check if Git is installed:
git --version
# Output: git version 2.43.0

# Git works OFFLINE — no internet needed at all
# Every project with Git has a hidden .git folder:
# my-project/
#   .git/          ← Git stores ALL history here (do not touch this)
#   index.html
#   style.css
#   app.py

# Basic Git workflow (completely local):
git init                          # start Git in this folder
git add index.html                # stage a file for saving
git commit -m "Added login page"  # save a snapshot with a message
git log                           # see the history of all snapshots
git checkout abc123               # go back to any old snapshot',
 1);

-- ---- SUBTOPIC: What is GitHub? ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000003',
 'f1000000-0000-0000-0000-000000000003',
 'What is GitHub?',
 '## What is GitHub?

**GitHub** is a **website** (github.com) that stores your Git repositories in the cloud — like Google Drive, but specifically built for code.

It was founded in 2008 and acquired by Microsoft in 2018. It is used by over 100 million developers worldwide.

## What GitHub Gives You

| Feature | What it does |
|---------|-------------|
| **Cloud storage** | Your code is backed up online, accessible anywhere |
| **Collaboration** | Teams work on the same project from different locations |
| **Pull Requests** | Propose changes and get them reviewed before merging |
| **Issues** | Track bugs and feature requests like a to-do list |
| **GitHub Actions** | Automatically test and deploy your code |
| **GitHub Pages** | Host your website for free |
| **Portfolio** | Show your projects to employers and clients |

## GitHub as Your Portfolio

When you apply for a developer job, the recruiter will ask: **"Do you have a GitHub profile?"**

Your GitHub shows:
- What projects you have built
- How consistently you code (the green contribution graph)
- How you write and structure your code

## GitHub Alternatives

- **GitLab** — popular for companies that self-host their repos
- **Bitbucket** — used by teams that also use Jira
- **Azure DevOps** — Microsoft''s enterprise offering

GitHub is just one option — but it is by far the most popular and the best for beginners.',
 '# GitHub is a WEBSITE — you do not install it
# Sign up for free at github.com

# Typical workflow after signing up:

# Step 1 — Create a repo on github.com (like creating a new folder)
# Step 2 — Connect your local Git project to GitHub:
git remote add origin https://github.com/yourname/myproject.git

# Step 3 — Upload (push) your code to GitHub:
git push origin main
# Now your code is live on the internet!

# Step 4 — Anyone can download (clone) your project:
git clone https://github.com/yourname/myproject.git

# Step 5 — Get the latest updates from GitHub:
git pull origin main',
 1);

-- ---- SUBTOPIC: Git vs GitHub ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000004',
 'f1000000-0000-0000-0000-000000000004',
 'Git vs GitHub — The Clear Difference',
 '## Git vs GitHub

This is the #1 confusion for beginners. Let''s clear it up once and for all.

| | **Git** | **GitHub** |
|-|---------|-----------|
| **What is it?** | A tool (software) | A website |
| **Where does it run?** | On your computer | On the internet |
| **Who made it?** | Linus Torvalds (2005) | Tom Preston-Werner (2008) |
| **What does it do?** | Tracks changes in your code locally | Stores and shares Git repos online |
| **Needs internet?** | ❌ No — works offline | ✅ Yes — it is online |
| **Free?** | Yes | Yes (paid plans for teams) |
| **Alternatives** | Mercurial, SVN | GitLab, Bitbucket |

## The Perfect Analogy

**Git** is like Microsoft Word''s **Track Changes** feature — it records every edit you make, right on your own computer.

**GitHub** is like **Google Docs** — it puts your document in the cloud so your whole team can see it, comment on it, and collaborate.

## The Golden Rules

- ✅ **You CAN use Git WITHOUT GitHub** — just track changes locally, never upload
- ❌ **You CANNOT use GitHub WITHOUT Git** — GitHub only understands Git repositories
- 🔗 **They work best together** — Git locally + GitHub in the cloud = full workflow

## In One Sentence

> **Git** is the tool on your computer that saves snapshots of your code.
> **GitHub** is the cloud where you share those snapshots with your team.

## Real Scenario

You are building a food delivery app with 3 teammates:
- **Git** lets each person save their work independently without affecting others
- **GitHub** is where everyone''s work comes together — like the shared Google Drive for code',
 '-- GIT commands (runs on YOUR computer — no internet):
git init                      -- start tracking a project
git add .                     -- stage all changes
git commit -m "first commit"  -- save a local snapshot
git log                       -- view history
-- All of this works with ZERO internet connection

-- GITHUB commands (needs internet — talking to the website):
git remote add origin https://github.com/user/repo.git  -- link to GitHub
git push origin main           -- upload commits to GitHub
git pull origin main           -- download latest from GitHub
git clone https://github.com/user/repo.git  -- copy a repo from GitHub

-- SUMMARY:
-- git init, add, commit, log  →  Git (local)
-- git push, pull, clone       →  GitHub (online)',
 1);

-- ---- SUBTOPIC: Real-World Use Cases ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000005',
 'f1000000-0000-0000-0000-000000000005',
 'Where is Git & GitHub Used in Real Life?',
 '## Real-World Use Cases

Git and GitHub are used in **almost every software company in the world**. Here are real scenarios you will face as a developer:

## Scenario 1: Team of 5 Developers

You join a startup building an e-commerce website. Five developers work on different features:
- Dev 1: Payment page
- Dev 2: Product listing
- Dev 3: User login
- Dev 4: Admin panel
- Dev 5: Mobile design

**Without Git:** Everyone emails code files. One person overwrites another''s work. Merging is a nightmare.

**With Git + GitHub:** Each developer works on their own **branch**. When done, they open a **Pull Request** to merge into the main code. No one''s work is overwritten.

## Scenario 2: Bug in Production at 2 AM

Your company''s app crashes. Users are complaining. Your manager asks: "What changed in the last deployment?"

**With Git:** You run `git log` — see the last 10 commits. You spot a bad database query pushed 3 hours ago. You run `git revert` and the app is fixed in minutes.

## Scenario 3: Open Source Contribution

You use a popular Python library and find a bug. You **fork** the repo on GitHub, fix the bug, and open a **Pull Request**. The maintainers review and merge it. Millions of developers now benefit from your fix.

## Scenario 4: Freelancer Delivering Work

Instead of sending a zip file to your client, you push the project to a GitHub repo and add the client as a collaborator. They can see every change, leave comments, and download the final version cleanly.

## Scenario 5: Auto-Deploy with CI/CD

Every time a developer pushes code to GitHub, GitHub Actions automatically:
1. Runs all tests
2. Checks code quality
3. Deploys to production if everything passes

This is how companies like Swiggy, Zomato, and Amazon deploy code dozens of times per day without breaking things.

## Who Uses Git?
- Every major tech company: Google, Microsoft, Meta, Amazon, Netflix
- Every startup — from day one
- Freelancers managing client projects
- Open source communities (Linux kernel itself is on GitHub)
- Data scientists versioning models and notebooks
- DevOps engineers managing infrastructure as code

**If you write code professionally, you will use Git every single day.**',
 '# Scenario 1: Team workflow
git checkout -b feature/payment-page  # Dev 1 creates their branch
git add payment.html
git commit -m "Add payment form UI"
git push origin feature/payment-page  # push to GitHub
# Opens Pull Request → team reviews → merged into main

# Scenario 2: Bug fix at 2 AM
git log --oneline          # see recent commits instantly
# abc1234 (2h ago) Update DB query for orders  ← found the bug!
git revert abc1234         # safely undo just that commit
git push origin main       # push the fix

# Scenario 5: CI/CD Pipeline in .github/workflows/deploy.yml
# (GitHub Actions — triggered automatically on every push)
# on: push to main
# jobs:
#   test → run pytest
#   deploy → push to production server',
 1);

-- ============================================================
-- CONCEPTS: TOPIC 2 - GIT BASICS
-- ============================================================

-- ---- SUBTOPIC: Installing & Configuring Git ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000006',
 'f2000000-0000-0000-0000-000000000001',
 'Installing Git',
 '## Installing Git

Git is a free tool you download and install on your computer once. After that, it works from the terminal/command line.

## Installation by OS

**Windows:**
1. Go to git-scm.com
2. Download the installer
3. Run it — keep all default settings
4. Open "Git Bash" (it gets installed with Git)

**macOS:**
Git comes pre-installed on Mac. Just open Terminal and type `git --version`. If not installed, it will prompt you to install it automatically.

**Linux (Ubuntu/Debian):**
```
sudo apt update
sudo apt install git
```

## Verify Installation

After installing, open your terminal and run:
```
git --version
```
You should see something like: `git version 2.43.0`

If you see this, Git is ready to use on your machine.',
 '# Check if Git is already installed:
git --version
# Output: git version 2.43.0   ← installed and working!
# If command not found → install Git from git-scm.com

# On Linux/Ubuntu — install with one command:
sudo apt update && sudo apt install git -y

# Confirm after install:
git --version',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000007',
 'f2000000-0000-0000-0000-000000000001',
 'Configuring Git — Your Identity',
 '## Configuring Git

After installing Git, the first thing you must do is **tell Git who you are**. This is important because every commit (save snapshot) you make is stamped with your name and email.

## Why This Matters

Imagine a team of 10 developers all committing code. When someone breaks something, Git shows exactly **who** committed what. If you have not set your name, your commits show up as "Unknown" — not professional.

## Two Required Settings

You only need to set these **once** — Git remembers them for all your projects:

1. **Your name** — shown in commit history
2. **Your email** — should match your GitHub email

## Global vs Local Config

- `--global` → applies to ALL projects on your machine (use this normally)
- `--local` → applies only to the current project (for work vs personal separation)

## Viewing Your Config

You can see all your Git settings anytime with `git config --list`.',
 '# Set your name and email — do this ONCE after installing Git:
git config --global user.name "Chandu"
git config --global user.email "chandu@example.com"

# Set the default branch name to "main" (modern standard):
git config --global init.defaultBranch main

# Verify your settings:
git config --list
# Output:
# user.name=Chandu
# user.email=chandu@example.com
# init.defaultBranch=main

# See a specific setting:
git config user.name
# Output: Chandu

# Change name for ONE specific project only:
cd my-work-project
git config --local user.name "Chandu Kumar"',
 2);

-- ---- SUBTOPIC: git init & git clone ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000008',
 'f2000000-0000-0000-0000-000000000002',
 'git init — Starting a New Repository',
 '## git init

`git init` tells Git: **"Start tracking this folder as a Git repository."**

It creates a hidden `.git` folder inside your project. This folder is where Git stores the entire history of your project — every commit, every branch, everything.

## When to Use It

Use `git init` when you are **starting a brand new project** from scratch on your own computer.

## What Happens Internally

After running `git init`, your folder looks like this:
```
my-project/
  .git/          ← hidden folder created by Git (do not modify this!)
  index.html
  style.css
```

The `.git` folder contains:
- `HEAD` — which branch you are on
- `objects/` — all your commit snapshots stored as compressed files
- `config` — project-level Git settings

## Important Notes

- You only run `git init` **once** per project
- Deleting the `.git` folder removes ALL Git history from the project
- Do not run `git init` inside an existing Git repo',
 '# Navigate to your project folder:
cd my-project

# Initialize Git tracking:
git init
# Output: Initialized empty Git repository in /my-project/.git/

# Git is now watching this folder
# Verify the hidden .git folder exists:
ls -a
# Output: .  ..  .git  index.html  style.css

# Check the current state:
git status
# Output: On branch main, No commits yet, nothing to commit

# Full start-to-first-commit flow:
mkdir my-app
cd my-app
git init
echo "# My App" > README.md
git add README.md
git commit -m "Initial commit"',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000009',
 'f2000000-0000-0000-0000-000000000002',
 'git clone — Copying an Existing Repository',
 '## git clone

`git clone` downloads a complete copy of an existing Git repository — including all files, all branches, and the entire commit history — onto your machine.

## When to Use It

Use `git clone` when you want to:
- Join an existing project (a colleague shares the GitHub link)
- Download an open-source project to use or contribute to
- Get a fresh copy of a project on a new machine

## What git clone Does

1. Creates a new folder on your machine
2. Downloads all files from the repository
3. Downloads all branches and the full commit history
4. Automatically sets up the connection to the original repo (called `origin`)

## Clone vs Download ZIP

GitHub has a "Download ZIP" button, but that only gives you the files — not the Git history. With `git clone`, you get everything, and you can push updates back.

## After Cloning

After cloning, you can immediately:
- Run the project
- Make changes
- Commit your changes
- Push back to GitHub (if you have permission)',
 '# Clone a repo from GitHub (downloads everything):
git clone https://github.com/username/project-name.git
# Output: Cloning into ''project-name''...
# A new folder "project-name" is created

# Clone into a custom folder name:
git clone https://github.com/username/project.git my-folder

# After cloning — everything is ready:
cd project-name
git log        # see full commit history
git branch     # see all branches

# Clone a specific branch only:
git clone -b develop https://github.com/username/project.git

# Check which remote URL is connected:
git remote -v
# Output:
# origin  https://github.com/username/project.git (fetch)
# origin  https://github.com/username/project.git (push)',
 2);

-- ---- SUBTOPIC: git status & git add ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000010',
 'f2000000-0000-0000-0000-000000000003',
 'git status — What is Happening in Your Repo?',
 '## git status

`git status` shows you the current state of your project. It answers the question: **"What has changed since my last commit?"**

Running `git status` never changes anything — it is completely safe to run at any time.

## What git status Shows

Git categorizes your files into three groups:

1. **Untracked files** — new files Git has never seen before (shown in red)
2. **Modified files** — files Git knows about, but you changed them (shown in red)
3. **Staged files** — files ready to be committed in the next snapshot (shown in green)

## The Three Zones of Git

Think of Git like a photography studio:
- **Working Directory** — where you write code (your actual files)
- **Staging Area** — where you prepare what goes into the next photo
- **Repository** — where all the committed snapshots are stored

`git status` shows you what is in zones 1 and 2.

## Short Status

`git status -s` gives a compact one-line-per-file view — useful when many files changed.',
 '# See what is going on in your project:
git status

# Output when nothing is changed:
# On branch main
# nothing to commit, working tree clean

# After creating a new file:
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#         newpage.html                   ← shown in RED

# After modifying an existing file:
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#         modified:   index.html         ← shown in RED

# After running git add:
# Changes to be committed:
#   (use "git restore --staged <file>..." to unstage)
#         new file:   newpage.html       ← shown in GREEN
#         modified:   index.html         ← shown in GREEN

# Short/compact view:
git status -s
# Output:
# M  index.html      ← M = modified
# ?? newfile.html    ← ?? = untracked',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000011',
 'f2000000-0000-0000-0000-000000000003',
 'git add — Staging Files for a Commit',
 '## git add

`git add` moves your changes from the **working directory** to the **staging area**. Think of it as selecting which changes will go into the next snapshot (commit).

## Why a Staging Area Exists

The staging area lets you be **selective**. For example:
- You changed 5 files today
- But only 3 are ready for the commit
- You can `git add` only those 3 and commit them
- The other 2 stay as work-in-progress

This is much better than "save everything all at once" — it keeps your project history clean and meaningful.

## Analogy

Think of `git add` like putting things in a shopping cart:
- `git add file.html` → add one item to cart
- `git add .` → add everything in the store to cart
- `git commit` → pay for what is in the cart (save the snapshot)

## Unstaging

If you accidentally staged something you did not mean to, you can remove it from staging with `git restore --staged filename`.',
 '# Stage a single file:
git add index.html

# Stage multiple specific files:
git add index.html style.css app.py

# Stage ALL changed/new files in the current folder:
git add .

# Stage all files of a specific type:
git add *.html

# Stage everything including deletions:
git add -A

# See what is staged:
git status
# Changes to be committed:
#   modified:   index.html   ← staged, ready to commit

# Unstage a file (remove from staging without losing changes):
git restore --staged index.html

# Stage only part of a file (interactive — choose specific lines):
git add -p index.html',
 2);

-- ---- SUBTOPIC: git commit & git log ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000012',
 'f2000000-0000-0000-0000-000000000004',
 'git commit — Saving a Snapshot',
 '## git commit

`git commit` takes everything in the staging area and saves it as a permanent snapshot in Git''s history. This snapshot is called a **commit**.

Every commit has:
- A **unique ID** (a 40-character hash like `a3c9d1f...`)
- **Your name and email** (from `git config`)
- A **timestamp**
- The **commit message** you wrote
- The **exact changes** made

## Writing Good Commit Messages

A commit message should explain **WHY** you made this change, not just what. Bad messages make it impossible to understand your project history later.

| Bad Message | Good Message |
|------------|-------------|
| `update` | `Fix login redirect after OAuth sign-in` |
| `changes` | `Add input validation for email field` |
| `asdfgh` | `Remove unused CSS causing layout shift` |

## The Commit Flow (Complete)

```
Edit files → git add → git commit
```

This is the core loop you will repeat hundreds of times every day as a developer.',
 '# Stage files first, then commit:
git add index.html style.css
git commit -m "Add homepage layout and navigation"

# Stage ALL tracked files and commit in one command:
git commit -am "Fix typo in header text"
# Note: -a only stages MODIFIED files, not brand new untracked files

# Commit with a detailed multi-line message:
git commit -m "Add user authentication

- Implement email/password login
- Add JWT token generation
- Set up protected routes"

# See what you just committed:
git show HEAD

# Undo the LAST commit but keep the changes (they go back to staged):
git reset --soft HEAD~1

# Change the message of the last commit (before pushing):
git commit --amend -m "Better commit message"',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000013',
 'f2000000-0000-0000-0000-000000000004',
 'git log — Viewing Commit History',
 '## git log

`git log` shows the full history of all commits in the current branch — who committed, when, and what message they wrote.

## Reading the Log Output

Each commit entry shows:
- **commit** → the unique SHA-1 hash (ID of this commit)
- **Author** → name and email of who committed
- **Date** → exact time of the commit
- **Message** → what they wrote as the commit message

## Useful Log Formats

`git log` alone shows verbose output. In real projects with hundreds of commits, you will use shorter formats.

## Why git log Matters

- **Debugging**: "Who changed this file and when?"
- **Reviewing**: What did we ship in this release?
- **Reverting**: Find the commit ID to go back to
- **Accountability**: Every team member''s contributions are visible',
 '# Full detailed log:
git log
# Output for each commit:
# commit a3c9d1f2e8b4...   ← commit ID (SHA-1 hash)
# Author: Chandu <chandu@example.com>
# Date:   Mon Mar 1 14:23:00 2026 +0530
#     Add login page with Google OAuth

# Short one-line format — most useful in real work:
git log --oneline
# Output:
# a3c9d1f Add login page with Google OAuth
# 7f2b890 Fix CSS layout on mobile
# 3d1c456 Initial project setup

# See last 5 commits only:
git log --oneline -5

# See commits with the actual changes (diff) shown:
git log -p

# See commits that changed a specific file:
git log --oneline -- index.html

# Visual branch history (useful when working with branches):
git log --oneline --graph --all

# See commits by a specific person:
git log --author="Chandu"',
 2);

-- ---- SUBTOPIC: git diff ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000014',
 'f2000000-0000-0000-0000-000000000005',
 'git diff — Seeing Exactly What Changed',
 '## git diff

`git diff` shows you the **exact line-by-line changes** in your files. It answers: "What exactly did I change since my last commit?"

## Reading diff Output

```
- old line    ← lines starting with - were removed (shown in RED)
+ new line    ← lines starting with + were added (shown in GREEN)
  unchanged   ← lines with no prefix are unchanged
```

## Three Common Uses

1. **`git diff`** — changes in working directory (not yet staged)
2. **`git diff --staged`** — changes that are staged and ready to commit
3. **`git diff commit1 commit2`** — difference between two commits

## Real-World Use

Before committing, run `git diff --staged` to review exactly what you are about to save. This is a good habit to catch accidental changes before they enter the project history.',
 '# See unstaged changes (what you changed but have NOT staged yet):
git diff

# Output example:
# diff --git a/index.html b/index.html
# --- a/index.html     (old version)
# +++ b/index.html     (new version)
# @@ -10,7 +10,7 @@
# -    <h1>Welcome</h1>       ← this line was removed
# +    <h1>Hello World</h1>   ← this line was added

# See staged changes (what you have added and are ready to commit):
git diff --staged

# Compare two commits:
git diff abc1234 def5678

# Compare current code with the last commit:
git diff HEAD

# See what changed in a specific file only:
git diff index.html

# Compare two branches:
git diff main feature/login',
 1);

-- ============================================================
-- CONCEPTS: TOPIC 3 - BRANCHING & MERGING
-- ============================================================

-- ---- SUBTOPIC: What is a Branch? ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000015',
 'f3000000-0000-0000-0000-000000000001',
 'What is a Branch?',
 '## What is a Branch?

A **branch** is an independent line of development. Think of it like a **parallel universe** for your code.

By default, every Git repo starts with one branch called **main** (or master in older repos). This is the "official" version of your project.

When you create a new branch, you get an **exact copy** of the main code that you can freely experiment with — without touching main at all.

## Simple Analogy

Imagine you are editing a Word document for your boss. Instead of editing the original, you **make a copy**, experiment on the copy, and if the boss approves, you replace the original with your improved copy.

In Git:
- **main branch** = the original document
- **feature branch** = your copy to experiment on
- **merging** = replacing the original with the approved copy

## Why Branches?

**Without branches:** Everyone directly edits the main code. One broken change ruins the project for everyone.

**With branches:** Each developer works in isolation. The main branch always stays clean and working.

## The main Branch

`main` (previously called `master`) is the default branch. In most teams:
- **main** = stable, production-ready code
- **feature branches** = work-in-progress code

You never push broken code directly to main.',
 '# See all branches in your repo:
git branch
# Output:
# * main      ← * means you are currently on this branch
#   feature/login

# The idea:
# main:           A → B → C              (stable)
# feature/login:  A → B → C → D → E     (your new work, isolated)

# main is completely unaffected while you work on feature/login
# When feature/login is ready, you merge D and E into main

# Real team branches:
# main                    ← production-ready
# develop                 ← integration branch
# feature/payment-page    ← one developer''s feature
# feature/user-profile    ← another developer''s feature
# hotfix/login-bug        ← urgent bug fix for production',
 1);

-- ---- SUBTOPIC: Creating & Switching Branches ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000016',
 'f3000000-0000-0000-0000-000000000002',
 'Creating and Switching Branches',
 '## Creating and Switching Branches

Two commands handle branch navigation:
- `git branch` — manage branches (create, list, delete)
- `git switch` or `git checkout` — move between branches

## Modern vs Old Commands

Git introduced `git switch` in version 2.23 as a cleaner replacement for `git checkout` (which does too many things). Both work, but `git switch` is recommended for switching branches.

## Branch Naming Conventions

Good branch names describe what the branch is for:
- `feature/user-authentication`
- `bugfix/fix-login-redirect`
- `hotfix/critical-payment-error`
- `release/v2.0`

The `/` is just a naming convention, not a folder. It helps organize branches visually.

## What Happens When You Switch

When you switch branches, Git:
1. Takes a snapshot of your current state
2. Replaces all files in your folder with the files from the target branch
3. Updates HEAD to point to the new branch

Your files literally change on disk when you switch branches.',
 '# Create a new branch:
git branch feature/login

# Switch to it:
git switch feature/login

# Create AND switch in one command (most common):
git switch -c feature/payment-page

# Old way (still works):
git checkout -b feature/payment-page

# See all branches (* = current branch):
git branch
# * feature/payment-page
#   feature/login
#   main

# Switch back to main:
git switch main

# Delete a branch (after it is merged):
git branch -d feature/login

# Force delete an unmerged branch:
git branch -D feature/login

# Rename a branch:
git branch -m old-name new-name

# See all remote branches too:
git branch -a',
 1);

-- ---- SUBTOPIC: Merging Branches ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000017',
 'f3000000-0000-0000-0000-000000000003',
 'Merging Branches',
 '## Merging Branches

**Merging** combines the work from one branch into another. When your feature is complete and tested, you merge it into `main`.

## How Merging Works

When you merge `feature/login` into `main`:
1. Git looks at the last common commit (where the branches split)
2. Git combines all changes from both branches
3. Git creates a new **merge commit** that joins both histories

## Fast-Forward Merge

If `main` has no new commits since you branched off, Git just moves the `main` pointer forward — no merge commit needed. This is called a **fast-forward merge**.

## Three-Way Merge

If both `main` and your feature branch have new commits since they split, Git performs a **three-way merge** — it compares both branch tips plus the common ancestor and combines changes automatically.

## The Golden Rule

Always merge in the correct direction:
- Switch to the **target branch** first (where you want changes to go)
- Then run `git merge <source-branch>` (the branch you are bringing in)',
 '# Step 1: Make sure you are on the target branch (where changes will go)
git switch main

# Step 2: Merge the feature branch into main
git merge feature/login
# Output: Merge made by the ''ort'' strategy
# or: Fast-forward (if no new commits on main)

# After merging, delete the feature branch (it is no longer needed):
git branch -d feature/login

# Real workflow:
git switch main           # 1. go to main
git pull origin main      # 2. get latest from GitHub (important in teams!)
git merge feature/login   # 3. merge feature
git push origin main      # 4. push merged result to GitHub
git branch -d feature/login  # 5. clean up

# See the full merge history visually:
git log --oneline --graph --all',
 1);

-- ---- SUBTOPIC: Resolving Merge Conflicts ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000018',
 'f3000000-0000-0000-0000-000000000004',
 'Resolving Merge Conflicts',
 '## What is a Merge Conflict?

A **merge conflict** happens when two branches both modified the **same line of the same file** in different ways. Git does not know which version to keep, so it asks you to decide.

## When Do Conflicts Happen?

**Scenario:** Dev 1 changes line 10 of `index.html` to say "Welcome to PyDeck". Dev 2 changes the same line 10 to say "Hello PyDeck User". When you try to merge — conflict!

Git cannot automatically pick one. It marks the conflict in the file and stops the merge.

## What the Conflict Looks Like in the File

```
<<<<<<< HEAD
Welcome to PyDeck          ← your current branch version
=======
Hello PyDeck User          ← the branch being merged in
>>>>>>> feature/login
```

## How to Resolve

1. Open the conflicted file
2. Delete the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. Keep the version you want (or combine both)
4. Save the file
5. Run `git add` on the resolved file
6. Run `git commit` to finish the merge

## Conflicts Are Normal

Every professional developer deals with merge conflicts regularly. They are not a sign of a mistake — they just mean two people edited the same thing. VS Code and most IDEs have built-in conflict resolution tools with a visual interface.',
 '# A merge conflict in action:
git switch main
git merge feature/login
# Auto-merging index.html
# CONFLICT (content): Merge conflict in index.html
# Automatic merge failed; fix conflicts and then commit the result.

# See which files have conflicts:
git status
# both modified:   index.html   ← needs manual resolution

# Open index.html — it will look like this:
# <<<<<<< HEAD
# <h1>Welcome to PyDeck</h1>
# =======
# <h1>Hello PyDeck User</h1>
# >>>>>>> feature/login

# Fix: remove the markers, keep what you want:
# <h1>Welcome to PyDeck</h1>   ← keep this, or pick the other, or combine

# After fixing the file:
git add index.html            # mark as resolved
git commit -m "Merge feature/login — resolved heading conflict"

# Abort the merge entirely (go back to before):
git merge --abort',
 1);

-- ============================================================
-- CONCEPTS: TOPIC 4 - WORKING WITH GITHUB
-- ============================================================

-- ---- SUBTOPIC: Creating a GitHub Repository ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000019',
 'f4000000-0000-0000-0000-000000000001',
 'Creating a GitHub Repository',
 '## Creating a GitHub Repository

A **repository** (or "repo") on GitHub is like a project folder in the cloud. It stores all your code, history, branches, and collaboration tools in one place.

## Two Ways to Start

**Option 1: Create on GitHub, then clone locally**
1. Go to github.com → click "New Repository"
2. Name it, choose public/private, add README
3. Copy the URL → `git clone <url>` on your machine
4. Start working inside the cloned folder

**Option 2: Push existing local project to GitHub**
1. You already have a local Git repo (`git init` done)
2. Create an empty repo on GitHub (do NOT add README)
3. Connect and push (commands below)

## Public vs Private

| | Public | Private |
|-|--------|---------|
| Visible to | Everyone | Only you and invited collaborators |
| Free? | Yes | Yes (up to a limit) |
| Use for | Open source, portfolio | Client work, proprietary code |

## Repository Settings

When creating a repo on GitHub:
- **README** — add this to describe your project
- **.gitignore** — tell Git which files to ignore (logs, node_modules, .env)
- **License** — only needed for open source projects',
 '# Option 1: Create on GitHub first, then work locally:
git clone https://github.com/yourname/my-project.git
cd my-project
# Start adding files and committing...

# Option 2: Push existing local project to new empty GitHub repo:

# (First create empty repo on github.com — do NOT add README)

# Connect your local repo to GitHub:
git remote add origin https://github.com/yourname/my-project.git

# Set the default branch to main and push:
git branch -M main
git push -u origin main
# -u sets origin/main as the upstream so future pushes are just "git push"

# Verify the connection:
git remote -v
# Output:
# origin  https://github.com/yourname/my-project.git (fetch)
# origin  https://github.com/yourname/my-project.git (push)',
 1);

-- ---- SUBTOPIC: git remote, push & pull ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000020',
 'f4000000-0000-0000-0000-000000000002',
 'git remote, push & pull',
 '## Connecting Local and Remote

When you work with GitHub, you have two copies of the repository:
- **Local repo** — on your computer (where you write code)
- **Remote repo** — on GitHub (the shared cloud version)

Git uses **remotes** to know where to send and receive code.

## git remote

`origin` is the conventional name for your main remote (the GitHub URL). You can have multiple remotes, but `origin` is the default.

## git push

`git push` uploads your local commits to GitHub. Think of it as syncing your local changes to the cloud.

## git pull

`git pull` downloads the latest commits from GitHub and merges them into your current branch. You should do this at the start of every work session to get your teammates'' latest changes.

## git fetch vs git pull

- `git fetch` → downloads changes but does NOT merge them
- `git pull` → downloads AND merges (= fetch + merge)

In most cases, use `git pull` for simplicity.

## The Daily Developer Workflow

```
Start of day:   git pull              ← get team''s latest work
Write code:     git add, git commit   ← save your progress
End of day:     git push              ← share your work
```',
 '# See which remote is connected:
git remote -v
# output:
# origin  https://github.com/yourname/project.git (fetch)
# origin  https://github.com/yourname/project.git (push)

# Add a remote (if not already connected):
git remote add origin https://github.com/yourname/project.git

# Push your commits to GitHub:
git push origin main          # push to main branch
git push origin feature/login # push a feature branch

# First push — set upstream so future pushes work with just "git push":
git push -u origin main
# After this, you can just type: git push

# Pull latest changes from GitHub:
git pull origin main

# Fetch without merging (safe — just downloads):
git fetch origin

# Push all branches at once:
git push --all origin',
 1);

-- ---- SUBTOPIC: README & .gitignore ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000021',
 'f4000000-0000-0000-0000-000000000003',
 'README.md — Your Project''s Front Page',
 '## README.md

The `README.md` file is the **first thing people see** when they visit your GitHub repository. It is written in **Markdown** (a simple formatting language).

A good README tells visitors:
- What the project does
- How to install and run it
- How to use it
- Who built it

## Why README Matters

- For your own projects: proves professionalism to employers
- For team projects: guides new members on how to set up
- For open source: helps contributors understand how to help

## Basic Markdown Syntax

```
# Heading 1
## Heading 2
**bold text**
*italic text*
`inline code`
- bullet point
```

## Good README Structure

1. Project name and one-line description
2. Screenshot or demo link (if applicable)
3. Tech stack used
4. Installation steps
5. How to use
6. Contributing guide (for open source)',
 '# Create a README.md file:
# Just create a file named README.md in your project root

# Example README.md content:
# # PyDeck
# A Python flashcard learning app with spaced repetition.
#
# ## Tech Stack
# - React (Frontend)
# - FastAPI (Backend)
# - Supabase (Database)
#
# ## Getting Started
# ```bash
# cd frontend
# npm install
# npm run dev
# ```
#
# ## Features
# - 6 learning paths: Python, SQL, Flask, Django, NumPy, Pandas
# - Spaced repetition algorithm
# - Progress tracking with streaks

# After creating README.md, commit it:
git add README.md
git commit -m "Add project README"
git push origin main',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000022',
 'f4000000-0000-0000-0000-000000000003',
 '.gitignore — Telling Git What to Ignore',
 '## .gitignore

`.gitignore` is a file that tells Git which files and folders to **completely ignore** — never track them, never commit them.

## Why You Need It

Some files should NEVER be in your Git repository:
- **Secret keys and passwords** (`.env` files with API keys)
- **Build output** (`node_modules/`, `__pycache__/`, `dist/`)
- **OS files** (`.DS_Store` on Mac, `Thumbs.db` on Windows)
- **Log files** (`.log`)
- **Uploaded files** that are too large

If you accidentally commit your `.env` file with secret keys to GitHub, **anyone can see them**. This is a serious security risk — always gitignore `.env`.

## How It Works

You create a file named `.gitignore` in the root of your project. Each line specifies a pattern — any file/folder matching that pattern is ignored by Git.

## GitHub Provides Templates

When creating a repo on GitHub, you can select a `.gitignore` template for your language (Python, Node, etc.) and GitHub auto-generates a sensible one.',
 '# Create .gitignore in your project root
# Each line = one pattern to ignore

# Example .gitignore for a Python + React project:
# .env                  ← NEVER commit secrets
# .env.local
# __pycache__/          ← Python cache files
# *.pyc
# node_modules/         ← 300MB of dependencies (not needed in repo)
# dist/                 ← build output
# .DS_Store             ← macOS system file
# *.log                 ← log files

# Check what Git currently tracks:
git status

# If you already committed a file and now want to ignore it:
git rm --cached .env          # remove from tracking (file stays on disk)
echo ".env" >> .gitignore     # add to .gitignore
git add .gitignore
git commit -m "Stop tracking .env file"

# Verify a file is being ignored:
git check-ignore -v .env
# Output: .gitignore:1:.env  .env   ← confirmed ignored',
 2);

-- ---- SUBTOPIC: Forking a Repository ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000023',
 'f4000000-0000-0000-0000-000000000004',
 'Forking a Repository',
 '## What is a Fork?

A **fork** is your own personal copy of someone else''s GitHub repository. It lives under your GitHub account and is completely independent from the original.

## Fork vs Clone

| | Fork | Clone |
|-|------|-------|
| **Where is the copy?** | Your GitHub account (online) | Your computer (local) |
| **What is it for?** | Contributing to projects you do not own | Working on any repo locally |
| **How?** | GitHub "Fork" button | `git clone <url>` |

You typically **fork first, then clone** when contributing to open source.

## When to Fork

1. **Contributing to open source** — you cannot push directly to someone else''s repo, so you fork it, make changes, and propose them via Pull Request
2. **Using a project as a starting template** — fork it and build your own version
3. **Experimenting** — try changes without risking the original

## The Fork → Contribute Workflow

1. Fork the repo on GitHub (click Fork button)
2. Clone your fork to your machine
3. Create a branch, make changes, commit
4. Push to your fork
5. Open a Pull Request from your fork to the original repo',
 '# Step 1: Click "Fork" button on GitHub → creates your copy at:
# https://github.com/YOURNAME/original-repo

# Step 2: Clone your fork locally:
git clone https://github.com/YOURNAME/original-repo.git
cd original-repo

# Step 3: Add the original repo as "upstream" (to get future updates):
git remote add upstream https://github.com/ORIGINALOWNER/original-repo.git

# Verify remotes:
git remote -v
# origin    https://github.com/YOURNAME/original-repo.git (your fork)
# upstream  https://github.com/ORIGINALOWNER/original-repo.git (original)

# Step 4: Create a branch and make your changes:
git switch -c fix/typo-in-readme

# Step 5: Push to your fork:
git push origin fix/typo-in-readme

# Step 6: Open Pull Request on GitHub from your fork to the original

# Keep your fork up to date with the original:
git fetch upstream
git switch main
git merge upstream/main
git push origin main',
 1);

-- ============================================================
-- CONCEPTS: TOPIC 5 - COLLABORATION ON GITHUB
-- ============================================================

-- ---- SUBTOPIC: Pull Requests ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000024',
 'f5000000-0000-0000-0000-000000000001',
 'Pull Requests',
 '## What is a Pull Request?

A **Pull Request** (PR) is a proposal to merge your branch''s changes into another branch (usually `main`). It is how teams **review and discuss code before it gets merged**.

The name "pull request" means: "Please pull my changes into your branch."

## The Pull Request Workflow

1. You create a feature branch and write your code
2. You push the branch to GitHub
3. On GitHub, you click "New Pull Request"
4. You select: merge `feature/login` → into `main`
5. Your teammates see exactly what changed (a diff view)
6. They can comment, request changes, or approve
7. Once approved, someone merges it

## Why PRs Are Powerful

- **Code review** — someone else catches bugs before they reach production
- **Discussion** — teammates can ask questions or suggest improvements on specific lines
- **History** — the PR page permanently records why a change was made
- **Protection** — main branch can require PR approval before anyone merges

## PR Description

A good PR description includes:
- What this PR does and why
- How to test it
- Screenshots if it is a UI change
- Any related Issues it closes',
 '# The complete Pull Request flow:

# Step 1: Create and work on a branch
git switch -c feature/user-profile
# ... make changes ...
git add .
git commit -m "Add user profile page"

# Step 2: Push the branch to GitHub
git push origin feature/user-profile

# Step 3: On GitHub:
# → Click "Compare & pull request" (GitHub shows this automatically)
# → Write a title: "Add user profile page"
# → Write a description explaining what and why
# → Select reviewers from your team
# → Click "Create pull request"

# After teammates review and approve:
# → Click "Merge pull request" on GitHub

# Step 4: Clean up after merge
git switch main
git pull origin main          # get the merged changes locally
git branch -d feature/user-profile  # delete local branch

# Link a PR to an Issue (auto-closes issue when merged):
# In PR description write: "Closes #42"',
 1);

-- ---- SUBTOPIC: Code Review ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000025',
 'f5000000-0000-0000-0000-000000000002',
 'Code Review on GitHub',
 '## What is Code Review?

**Code review** is the process where your teammates read through your code (in a Pull Request) and give feedback before it gets merged.

It is one of the most valuable practices in professional software development.

## Why Code Review Matters

- **Catches bugs** before they reach users
- **Improves code quality** — another perspective spots things you missed
- **Shares knowledge** — team members learn from each other
- **Documents decisions** — discussion is recorded on the PR forever
- **Prevents security issues** — a second pair of eyes catches vulnerabilities

## How to Review a PR on GitHub

1. Open the Pull Request
2. Click "Files changed" tab — see every line that was added/removed
3. Click the `+` on any line to add an inline comment
4. Choose "Comment", "Approve", or "Request changes"

## Review Statuses

| Status | Meaning |
|--------|---------|
| **Approve** | Code looks good, ready to merge |
| **Request changes** | Found issues, needs fixes before merging |
| **Comment** | Left notes but not formally approving or blocking |

## Being a Good Reviewer

- Be specific: "This could be a bug if `user` is null" not just "bad code"
- Be kind: You''re reviewing the code, not the person
- Ask questions: "Why did you choose this approach?" opens discussion
- Acknowledge good things: "Nice solution here!" builds team culture',
 '# On GitHub, reviewers use the web UI
# But here is the command line equivalent for reviewing locally:

# Get a colleague''s PR branch and test it locally:
git fetch origin
git switch feature/user-profile  # switch to the PR branch
# Run the app, test manually, look at the code

# Leave comments on GitHub by going to:
# Pull Request → Files Changed → click + on any line

# Common review actions:
# ✅ Approve  — "LGTM" (Looks Good To Me)
# 🔁 Request Changes — "Please fix X before I can approve"
# 💬 Comment — "I noticed this, worth discussing"

# Author responds to review by making more commits on the same branch:
git add fixed-file.py
git commit -m "Address review feedback — add null check"
git push origin feature/user-profile
# PR automatically updates with the new commit',
 1);

-- ---- SUBTOPIC: Issues & Project Boards ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000026',
 'f5000000-0000-0000-0000-000000000003',
 'GitHub Issues & Project Boards',
 '## GitHub Issues

**Issues** are GitHub''s built-in task tracker. They are used to report bugs, request features, or track any to-do item related to the project.

Anyone (even people who cannot contribute code) can open an Issue.

## What Issues Are Used For

- **Bug reports**: "The login button does nothing on mobile"
- **Feature requests**: "Can you add dark mode?"
- **Questions**: "How do I set up the project locally?"
- **Tasks**: "Write tests for the payment module"

## Issue Features

- **Labels** — categorize issues (bug, enhancement, documentation)
- **Assignees** — assign to a specific developer
- **Milestones** — group issues into a release goal
- **Linked PRs** — link to the Pull Request that fixes this issue

## Closing Issues via PRs

If your PR fixes Issue #42, write `Closes #42` in the PR description. When the PR is merged, GitHub automatically closes the issue.

## GitHub Projects (Project Boards)

GitHub Projects is a Kanban-style board built into GitHub. It lets you organize Issues and PRs into columns like:
- **To Do** → **In Progress** → **Done**

It is like Trello but directly connected to your code. Useful for managing sprints in a team.',
 '# Issues are managed on GitHub.com (no CLI needed for basic use)
# But you can reference issues in commit messages:

# Referencing an issue in a commit message:
git commit -m "Fix null pointer crash on login page (fixes #23)"
# When this commit reaches main, GitHub closes Issue #23 automatically

# Keywords that close issues:
# closes #42, fixes #42, resolves #42

# Create issues from command line using GitHub CLI (gh):
gh issue create --title "Login button broken on mobile" --body "Steps to reproduce..."
gh issue list                    # see open issues
gh issue close 42                # close issue #42

# GitHub CLI for PRs:
gh pr create --title "Fix mobile login button" --body "Closes #42"
gh pr list                       # see open PRs
gh pr view 15                    # see details of PR #15',
 1);

-- ============================================================
-- CONCEPTS: TOPIC 6 - ADVANCED GIT
-- ============================================================

-- ---- SUBTOPIC: Undoing Changes ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000027',
 'f6000000-0000-0000-0000-000000000001',
 'Undoing Changes in Git',
 '## Undoing Changes

One of Git''s superpowers is the ability to **undo almost anything**. Here are the main scenarios and their solutions.

## Scenario 1: You have not staged yet

You changed a file but want to discard the change completely and go back to the last commit version.

Use: `git restore <file>`

## Scenario 2: You staged but have not committed

You ran `git add` but want to unstage (undo the add) without losing the changes.

Use: `git restore --staged <file>`

## Scenario 3: You committed but have not pushed

You committed something wrong and want to undo the commit.

- `git reset --soft HEAD~1` → undo commit, keep changes staged
- `git reset --mixed HEAD~1` → undo commit, keep changes unstaged
- `git reset --hard HEAD~1` → undo commit AND delete all changes ⚠️

## Scenario 4: You pushed to GitHub (shared history)

NEVER use `git reset` on commits that others already pulled. Use `git revert` instead — it creates a new commit that undoes the bad one, preserving history.

## The Safety Rule

- `git restore` and `git revert` → **safe, non-destructive**
- `git reset --hard` → **destructive, use with caution**',
 '# Scenario 1: Discard unstaged changes to a file
git restore index.html         # file goes back to last commit version

# Scenario 2: Unstage a file (undo git add)
git restore --staged index.html  # file is unstaged but changes kept

# Scenario 3: Undo the last commit
git reset --soft HEAD~1    # undo commit, changes stay staged (safest)
git reset --mixed HEAD~1   # undo commit, changes stay but unstaged
git reset --hard HEAD~1    # undo commit AND delete all changes ⚠️ DANGEROUS

# Scenario 4: Undo a pushed commit safely (creates new commit)
git revert abc1234          # creates a new "reverse" commit
git push origin main        # push the revert — history preserved

# Find the commit hash to revert:
git log --oneline
# abc1234 Added broken payment code  ← revert this
# def5678 Updated homepage

# Reset entire working directory to last commit (dangerous!):
git reset --hard HEAD       # discards ALL uncommitted changes',
 1);

-- ---- SUBTOPIC: git stash ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000028',
 'f6000000-0000-0000-0000-000000000002',
 'git stash — Temporarily Save Work',
 '## What is git stash?

`git stash` temporarily saves your uncommitted changes and gives you a clean working directory — without committing.

## When Do You Need It?

**Scenario:** You are in the middle of building a new feature (files half-done, cannot commit yet). Your manager suddenly says there is an urgent bug on `main` that needs to be fixed NOW.

You cannot switch branches with uncommitted changes (Git will complain or might overwrite your work). You are not ready to commit your half-done feature either.

**Solution:** Stash your changes → switch to main → fix the bug → come back → pop the stash → continue where you left off.

## Stash vs Commit

| | Stash | Commit |
|-|-------|--------|
| **Complete?** | Work-in-progress | Finished change |
| **Shows in log?** | No | Yes |
| **Shared with team?** | No | Yes (after push) |
| **Use case** | Temporarily set aside | Permanently save |

## Multiple Stashes

You can have multiple stashes (they stack up). Use `git stash list` to see them all.',
 '# Stash all uncommitted changes:
git stash
# Output: Saved working directory and index state WIP on main: a3c9d1f Add login page

# Now your working directory is clean — switch branches freely:
git switch main
# ... fix the urgent bug ...
git add bugfix.py
git commit -m "Hotfix: fix payment crash"
git push origin main

# Come back to your feature branch:
git switch feature/new-dashboard

# Restore your stashed changes:
git stash pop
# Output: On branch feature/new-dashboard
# Changes not staged for commit: ...
# Now all your half-done changes are back!

# See all stashes:
git stash list
# stash@{0}: WIP on feature/new-dashboard: 7f2b890 Start dashboard
# stash@{1}: WIP on feature/login: abc1234 Half-done login

# Apply a specific stash (without deleting it):
git stash apply stash@{1}

# Delete a stash:
git stash drop stash@{0}

# Clear all stashes:
git stash clear',
 1);

-- ---- SUBTOPIC: Tags & Releases ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000029',
 'f6000000-0000-0000-0000-000000000003',
 'Tags & Releases',
 '## What are Git Tags?

A **tag** is a label that marks a specific commit as important — usually a release version like `v1.0`, `v2.3.1`.

Unlike branches (which move forward as you commit), **tags are permanent** — they always point to the same commit forever.

## Semantic Versioning

Most software uses **semantic versioning**: `v MAJOR.MINOR.PATCH`
- **MAJOR** — breaking changes (v1.0 → v2.0)
- **MINOR** — new features, backward compatible (v1.0 → v1.1)
- **PATCH** — bug fixes (v1.0.0 → v1.0.1)

Example: `v2.3.1` = major version 2, minor version 3, patch 1

## Annotated vs Lightweight Tags

- **Lightweight tag** — just a label pointing to a commit
- **Annotated tag** — includes tagger name, date, and message (recommended for releases)

## GitHub Releases

When you push a tag to GitHub, you can create a **Release** from it. A GitHub Release:
- Shows a changelog / description
- Can include downloadable files (zip, exe, apk)
- Notifies people who watch the repo',
 '# Create a lightweight tag:
git tag v1.0

# Create an annotated tag (recommended for releases):
git tag -a v1.0.0 -m "First stable release — includes login and dashboard"

# See all tags:
git tag
# v0.9.0
# v1.0.0

# Push tags to GitHub (tags are not pushed automatically):
git push origin v1.0.0      # push one specific tag
git push origin --tags      # push ALL tags at once

# See details of a specific tag:
git show v1.0.0

# Tag an older commit (not the latest):
git tag -a v0.9.0 abc1234 -m "Beta release"

# Delete a tag locally:
git tag -d v1.0.0

# Delete a tag from GitHub:
git push origin --delete v1.0.0

# Create a GitHub Release from a tag:
# → On GitHub: Releases → Draft a new release → pick tag → add description',
 1);

-- ---- SUBTOPIC: Git Workflow Best Practices ----
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fa000000-0000-0000-0000-000000000030',
 'f6000000-0000-0000-0000-000000000004',
 'Git Workflow Best Practices',
 '## The Professional Git Workflow

Here are the practices used by real development teams that make Git work smoothly.

## 1. Commit Often, Push Daily

- Commit every time you complete a small, logical unit of work
- Do not wait to commit "when the feature is done" — commit small steps
- Push at the end of every work session so your work is backed up

## 2. Write Meaningful Commit Messages

Good format: `<type>: <short description>`

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

Examples:
- `feat: add user profile page`
- `fix: resolve null pointer on login`
- `docs: update README setup instructions`

## 3. Never Commit Secrets

Always gitignore: `.env`, `config.json` with passwords, API keys, certificates.
If you accidentally commit a secret — it is compromised. Change the key immediately.

## 4. Use Feature Branches

- Never work directly on `main`
- Create a new branch for every feature or bug fix
- Keep `main` always deployable

## 5. Pull Before You Push

Always `git pull origin main` before starting work and before pushing to avoid conflicts.

## 6. Review Your Changes Before Committing

Run `git diff --staged` before every commit to see exactly what you are about to save. Avoid committing debug `console.log` statements or test code accidentally.

## 7. Keep Pull Requests Small

Small PRs (under 400 lines of change) are reviewed faster and more thoroughly. Large PRs get rubber-stamped or create conflict nightmares.',
 '# Daily developer workflow:
git pull origin main              # 1. start fresh with latest changes
git switch -c feature/new-thing   # 2. create a branch
# ... write code ...
git diff --staged                 # 3. review before committing
git add specific-file.py          # 4. stage specific files (not git add .)
git commit -m "feat: add user analytics dashboard"  # 5. clear message
git push origin feature/new-thing # 6. push and open PR

# Commit message format (Conventional Commits):
# feat: add login with Google OAuth
# fix: resolve mobile layout issue
# refactor: simplify authentication logic
# docs: add API documentation
# test: add unit tests for user service
# chore: update dependencies

# Protect your main branch (set on GitHub):
# Settings → Branches → Add rule → Require PR before merging
# This forces ALL changes through code review

# Check what you are about to commit:
git status             # overview
git diff --staged      # exact line changes
# Then commit confidently',
 1);

-- ============================================================
-- CONCEPT-TYPE FLASHCARDS (card_type = ''concept'')
-- ============================================================

-- Topic 1: Introduction
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('f1000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000001',
 'Version control is a system that tracks ____ to files over time.',
 'changes',
 'Version control records every change — what changed, who changed it, and when. This lets you go back to any previous version and collaborate without overwriting each other''s work.',
 'concept'),

('f1000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000001',
 'Git was created by ____, the same person who created the Linux kernel.',
 'Linus Torvalds',
 'Linus Torvalds created Git in 2005 specifically to manage the Linux kernel source code. He needed a fast, distributed, and reliable version control system after a dispute with BitKeeper.',
 'concept'),

('f1000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000001',
 'Git stores its entire project history in a hidden folder called ____.',
 '.git',
 'The .git folder is created when you run "git init". It contains all commits, branches, and settings. Deleting this folder removes the entire Git history from the project.',
 'concept'),

('f1000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000001',
 'GitHub is a ____ that stores Git repositories online.',
 'website (cloud platform)',
 'GitHub (github.com) is a web-based hosting service for Git repositories. It adds collaboration features like Pull Requests, Issues, and GitHub Actions on top of standard Git.',
 'concept'),

('f1000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000001',
 'You ____ use Git without GitHub, but you ____ use GitHub without Git.',
 'can, cannot',
 'Git is the local tool that runs on your machine. GitHub is just one platform to host Git repos. But GitHub only understands Git repositories — it cannot work without Git.',
 'concept'),

('f1000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000001',
 'Git is a ____ version control system, meaning every developer has the full history.',
 'distributed',
 'Unlike centralized VCS (like SVN) where history lives only on a server, Git gives every developer a complete copy of the repository. You can work and commit offline.',
 'concept'),

('f1000000-0000-0000-0000-000000000005', 'b7000000-0000-0000-0000-000000000001',
 'In teams, ____ lets each developer work independently on features without breaking the shared codebase.',
 'Git branching',
 'Each developer creates their own branch — an isolated copy of the code. They work freely, commit, and merge back via Pull Requests when ready. Main stays clean and working.',
 'concept');

-- Topic 2: Git Basics
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('f2000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000002',
 'The command to set your name in Git for all projects is ____.',
 'git config --global user.name "Your Name"',
 'This stamps your name on every commit you make. Without setting this, commits show "Unknown". The --global flag applies it to all Git repos on your machine.',
 'concept'),

('f2000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000002',
 '____ creates a new empty Git repository in the current folder.',
 'git init',
 'git init creates a hidden .git folder that stores all project history. You run it once per project when starting from scratch. It does not affect your existing files.',
 'concept'),

('f2000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000002',
 '____ downloads a complete copy of a remote repository, including all history.',
 'git clone',
 'git clone <url> creates a new folder, downloads all files and commits, and automatically sets up the "origin" remote pointing back to the source.',
 'concept'),

('f2000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000002',
 'Files shown in red by git status are ____ or ____ files.',
 'untracked, modified',
 'Red means Git is not going to include these in the next commit. You need to run "git add" to stage them. Green means staged and ready to commit.',
 'concept'),

('f2000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000002',
 'The ____ command moves changes from the working directory to the staging area.',
 'git add',
 'git add prepares files for the next commit. "git add ." stages all changed files. "git add filename" stages one specific file. Nothing is saved to history until you commit.',
 'concept'),

('f2000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000002',
 'A ____ is a permanent snapshot saved in Git history with an ID, author, date, and message.',
 'commit',
 'Every "git commit" creates an immutable record. Each commit gets a SHA-1 hash ID. You can jump back to any commit at any time with git checkout.',
 'concept'),

('f2000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000002',
 '____ --oneline shows a compact one-line summary of each commit.',
 'git log',
 'git log --oneline is the most used format in real work. It shows: short hash + commit message for each commit. Use -5 to limit to 5 commits.',
 'concept'),

('f2000000-0000-0000-0000-000000000005', 'b7000000-0000-0000-0000-000000000002',
 'git diff shows changes in the ____ area, while git diff --staged shows changes in the ____ area.',
 'working directory, staging',
 'git diff compares your current files vs what was last committed. git diff --staged compares what is staged vs what was last committed. Both show + for additions and - for removals.',
 'concept');

-- Topic 3: Branching & Merging
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('f3000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000003',
 'A ____ is an independent line of development that lets you work without affecting the main code.',
 'branch',
 'A branch is like a parallel universe copy of your project. Changes on a branch do not affect main until you merge. The default branch is called "main".',
 'concept'),

('f3000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000003',
 'The modern command to create and switch to a new branch in one step is ____.',
 'git switch -c branch-name',
 'git switch -c creates and switches in one command. The older equivalent is "git checkout -b branch-name". Both work, but git switch is clearer in intent.',
 'concept'),

('f3000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000003',
 'To merge "feature/login" into main, you first switch to ____ then run ____.',
 'main, git merge feature/login',
 'You always merge INTO your current branch. So switch to the target branch (main) first, then run git merge <source>. Git brings the source branch''s commits into main.',
 'concept'),

('f3000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000003',
 'A merge conflict happens when two branches edited the ____ in different ways.',
 'same line of the same file',
 'Git can auto-merge changes to different lines or files. But when two branches both change the exact same line, Git cannot decide which version to keep — it marks it as a conflict for you to resolve.',
 'concept'),

('f3000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000003',
 'After fixing a merge conflict manually, you run ____ then ____ to complete the merge.',
 'git add, git commit',
 'After editing the conflicted file to remove the conflict markers and keep the right code, run git add to mark it resolved, then git commit to finalize the merge.',
 'concept');

-- Topic 4: Working with GitHub
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('f4000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000004',
 '____ uploads your local commits to GitHub.',
 'git push',
 'git push origin main sends your commits to the "main" branch on GitHub (origin). Use -u flag the first time to set upstream: git push -u origin main.',
 'concept'),

('f4000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000004',
 '____ downloads the latest commits from GitHub and merges them into your current branch.',
 'git pull',
 'git pull = git fetch + git merge. It downloads AND integrates remote changes. Always pull before starting work to get your team''s latest changes.',
 'concept'),

('f4000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000004',
 'The ____ file tells Git which files and folders to never track or commit.',
 '.gitignore',
 '.gitignore patterns like "node_modules/", ".env", "*.log" make Git ignore those files. Always ignore secret files like .env that contain API keys and passwords.',
 'concept'),

('f4000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000004',
 'A ____ is your personal copy of someone else''s GitHub repository under your own account.',
 'fork',
 'Forking creates an independent copy on your GitHub account. You can freely experiment without affecting the original. Used in open source: fork → change → Pull Request back to original.',
 'concept');

-- Topic 5: Collaboration
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('f5000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000005',
 'A ____ is a proposal on GitHub to merge one branch into another, with discussion and review.',
 'Pull Request (PR)',
 'A PR shows exactly what changed (the diff), lets teammates comment on specific lines, approve or request changes, and records the entire decision history permanently on GitHub.',
 'concept'),

('f5000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000005',
 '____ is the process of teammates reading and giving feedback on code before it is merged.',
 'Code review',
 'Code review catches bugs, improves quality, shares knowledge, and prevents security issues. It is one of the most valuable practices in professional software development.',
 'concept'),

('f5000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000005',
 'Writing "Closes #42" in a PR description will automatically ____ Issue #42 when merged.',
 'close',
 'GitHub recognizes keywords like "closes", "fixes", "resolves" followed by an issue number. When the PR is merged into main, GitHub auto-closes the linked issue.',
 'concept');

-- Topic 6: Advanced Git
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('f6000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000006',
 '____ safely undoes a pushed commit by creating a new "reverse" commit.',
 'git revert',
 'git revert <hash> creates a new commit that undoes the changes. Unlike reset, it does not rewrite history — safe to use on shared/pushed commits.',
 'concept'),

('f6000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000006',
 'git reset --hard HEAD~1 removes the last commit AND ____ all changes.',
 'permanently deletes',
 'git reset --hard is destructive — you lose all uncommitted changes. Use --soft to undo the commit but keep changes staged. Only use --hard on local, unpushed commits.',
 'concept'),

('f6000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000006',
 '____ temporarily saves uncommitted work so you can switch branches cleanly.',
 'git stash',
 'git stash hides your changes, giving you a clean working directory. git stash pop restores them. Perfect for urgent hotfixes when you are mid-feature.',
 'concept'),

('f6000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000006',
 'Git tags use semantic versioning format ____ where each number represents MAJOR, MINOR, PATCH.',
 'vX.Y.Z',
 'v1.2.3 means major version 1, minor version 2, patch version 3. Major = breaking changes, Minor = new features, Patch = bug fixes. Tags permanently mark release points.',
 'concept');

-- ============================================================
-- MCQ FLASHCARDS (card_type = ''quiz'')
-- ============================================================

-- Topic 1: Introduction
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('f1000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000001',
 'What does Git store in the hidden .git folder?',
 'The complete project history — all commits, branches, and settings',
 'The .git folder is Git''s internal database. It contains every snapshot ever committed, all branches, your config settings, and more. Never manually edit files inside .git.',
 'Only the latest version of files', 'The complete project history — all commits, branches, and settings', 'Your GitHub username and password', 'A backup of deleted files', 'b', 'quiz'),

('f1000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000001',
 'Which statement about Git and GitHub is TRUE?',
 'You can use Git without GitHub, but not GitHub without Git',
 'Git is the local version control tool. GitHub is a hosting platform for Git repos. Git works completely offline without GitHub. But GitHub only stores Git repositories — it requires Git.',
 'Git and GitHub are the same thing', 'GitHub was created before Git', 'You need GitHub to use Git', 'You can use Git without GitHub, but not GitHub without Git', 'd', 'quiz'),

('f1000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000001',
 'What type of version control system is Git?',
 'Distributed',
 'In a distributed VCS, every developer has the full history locally. In a centralized VCS (like SVN), only the server has the full history. Distributed means you can work offline.',
 'Centralized', 'Local-only', 'Distributed', 'Cloud-based', 'c', 'quiz'),

('f1000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000001',
 'What is GitHub primarily used for?',
 'Hosting Git repositories online and enabling collaboration',
 'GitHub stores Git repos in the cloud and adds collaboration tools: Pull Requests, Issues, Actions, Pages. It is not a code editor, not a programming language, and not a database.',
 'Writing and running code', 'Hosting Git repositories online and enabling collaboration', 'Teaching programming', 'Replacing Git with a better system', 'b', 'quiz'),

-- Topic 2: Git Basics
('f2000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000002',
 'What does "git add ." do?',
 'Stages all changed and new files in the current directory for the next commit',
 'git add . stages everything — modified files and new untracked files. It does NOT commit anything. It just moves changes to the staging area. Use before git commit.',
 'Commits all changes immediately', 'Stages all changed and new files in the current directory for the next commit', 'Pushes changes to GitHub', 'Creates a new branch', 'b', 'quiz'),

('f2000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000002',
 'Which command shows a short one-line summary of each commit?',
 'git log --oneline',
 'git log --oneline condenses each commit to: short_hash + message. Very useful in real projects with many commits. Add --graph to see branch relationships visually.',
 'git history', 'git show --short', 'git log --oneline', 'git commits --list', 'c', 'quiz'),

('f2000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000002',
 'What is the difference between git init and git clone?',
 'git init starts a new empty repo; git clone downloads an existing repo',
 'git init creates a fresh empty repo in your current folder. git clone downloads a complete existing repo (with all history) from a URL. Use init for new projects, clone for existing ones.',
 'They do the same thing', 'git init downloads a repo; git clone creates a new one', 'git init starts a new empty repo; git clone downloads an existing repo', 'git clone only works with GitHub', 'c', 'quiz'),

('f2000000-0000-0000-0000-000000000005', 'b7000000-0000-0000-0000-000000000002',
 'In git diff output, lines starting with + are ____.',
 'Lines that were added',
 'In diff output: + (green) = lines added in the new version. - (red) = lines removed from the old version. Lines with no prefix = unchanged context lines.',
 'Lines that were deleted', 'Lines that were added', 'Lines with errors', 'Comment lines', 'b', 'quiz'),

-- Topic 3: Branching & Merging
('f3000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000003',
 'Which command creates a new branch AND switches to it in one step?',
 'git switch -c branch-name',
 'git switch -c (or the older git checkout -b) creates and switches in one command. Without -c, git switch just switches to an existing branch.',
 'git branch new-branch', 'git switch branch-name', 'git switch -c branch-name', 'git create branch-name', 'c', 'quiz'),

('f3000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000003',
 'To merge "feature/login" into main, which sequence is correct?',
 'git switch main → git merge feature/login',
 'You merge INTO your current branch. So switch to the target (main) first, then merge the source (feature/login). Doing it backwards would merge main into your feature branch.',
 'git merge feature/login → git switch main', 'git switch feature/login → git merge main', 'git switch main → git merge feature/login', 'git push feature/login main', 'c', 'quiz'),

('f3000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000003',
 'What does the <<<<<<< HEAD marker in a file mean?',
 'A merge conflict — this is your current branch''s version of the conflicting code',
 'Git inserts conflict markers when it cannot auto-merge. <<<<<<< HEAD = your branch, ======= = divider, >>>>>>> feature = incoming branch. You manually edit the file to resolve it.',
 'A syntax error in the code', 'A merge conflict — this is your current branch''s version', 'A Git comment', 'The beginning of a new function', 'b', 'quiz'),

-- Topic 4: Working with GitHub
('f4000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000004',
 'What does "git pull" do?',
 'Downloads AND merges the latest changes from GitHub into your current branch',
 'git pull = git fetch + git merge. It downloads remote commits and integrates them automatically. git fetch only downloads without merging — useful when you want to review before merging.',
 'Uploads your commits to GitHub', 'Downloads files without merging', 'Downloads AND merges the latest changes from GitHub', 'Creates a backup of your repo', 'c', 'quiz'),

('f4000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000004',
 'Why should .env files always be added to .gitignore?',
 'They contain secret API keys and passwords that must never be public',
 'If you commit a .env file to a public GitHub repo, anyone can see your database passwords, API keys, etc. This is a serious security breach. Always gitignore .env before your first commit.',
 'They are too large for Git', 'They contain secret API keys and passwords', 'Git cannot read .env files', 'They slow down git push', 'b', 'quiz'),

('f4000000-0000-0000-0000-000000000004', 'b7000000-0000-0000-0000-000000000004',
 'What is a fork on GitHub?',
 'Your personal copy of someone else''s repository on your GitHub account',
 'Forking creates an independent copy under your account. You can freely change it without affecting the original. Used in open source: fork → modify → Pull Request to original.',
 'Deleting a repository', 'Downloading a zip of the repo', 'Your personal copy of someone else''s repository', 'Creating a new branch', 'c', 'quiz'),

-- Topic 5: Collaboration
('f5000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000005',
 'What is the main purpose of a Pull Request?',
 'To propose merging changes and allow team review before they enter the main branch',
 'A PR lets teammates see exactly what changed, comment on specific lines, approve or request changes. Nothing gets merged until reviewed. This is the core collaboration workflow in teams.',
 'To pull the latest changes from GitHub', 'To delete a branch after it is done', 'To propose changes and allow team review before merging', 'To create a backup of the main branch', 'c', 'quiz'),

('f5000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000005',
 'If you write "Fixes #15" in a PR description, what happens when the PR is merged?',
 'GitHub automatically closes Issue #15',
 'GitHub recognizes keywords: closes, fixes, resolves followed by an issue number. When the PR is merged into the default branch, GitHub auto-closes the linked issue.',
 'PR #15 gets deleted', 'Issue #15 gets a comment', 'GitHub automatically closes Issue #15', 'The PR is renamed to #15', 'c', 'quiz'),

-- Topic 6: Advanced Git
('f6000000-0000-0000-0000-000000000001', 'b7000000-0000-0000-0000-000000000006',
 'Which command safely undoes a pushed commit without rewriting history?',
 'git revert',
 'git revert creates a new commit that reverses the changes of a target commit. The original commit stays in history. Safe for shared branches. git reset rewrites history — dangerous for pushed commits.',
 'git reset --hard', 'git undo', 'git revert', 'git delete commit', 'c', 'quiz'),

('f6000000-0000-0000-0000-000000000002', 'b7000000-0000-0000-0000-000000000006',
 'When would you use git stash?',
 'When you need to switch branches but have uncommitted work-in-progress',
 'git stash hides your current changes so you can switch branches cleanly. You restore them later with git stash pop. Perfect for urgent bug fixes when you are mid-feature.',
 'To save a commit message for later', 'To push all branches at once', 'When you need to switch branches but have uncommitted work-in-progress', 'To delete a branch permanently', 'c', 'quiz'),

('f6000000-0000-0000-0000-000000000003', 'b7000000-0000-0000-0000-000000000006',
 'In semantic versioning v2.3.1, what does the "3" represent?',
 'Minor version — new features added without breaking existing functionality',
 'Semantic versioning: MAJOR.MINOR.PATCH. Major = breaking changes. Minor = new backward-compatible features. Patch = bug fixes. v2.3.1 = 2nd major, 3rd minor update, 1st patch.',
 'Patch — bug fixes only', 'Major — breaking changes', 'Minor — new backward-compatible features', 'The build number', 'c', 'quiz');
