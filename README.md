💰 Smart Personal Finance & Expense Tracker
A beautiful Flutter expense tracking app that helps you manage finances, set budgets, and track spending with powerful analytics.

🚀 Features
💸 Core Functionality
Transaction Management: Add, edit, delete income and expenses

Smart Categorization: Pre-defined categories with emojis

Real-time Balance Tracking: Automatic income vs expense calculations

Local Data Storage: Offline-first with Hive database

📊 Analytics & Visualization
Dashboard Overview: Financial summary at a glance

Expense Charts: Interactive pie charts by category

Recent Transactions: Quick access to latest activities

🎯 Budget Management
Category Budgets: Set monthly limits per spending category

Smart Alerts: Visual warnings when approaching budgets

Progress Tracking: Real-time budget usage percentages

🎨 User Experience
Material Design 3: Modern, intuitive interface

Dark/Light Theme: Automatic system theme detection

📱 Screenshots
Dashboard	Transactions	Budgets
🏗️ Architecture
📁 Project Structure
text
lib/
├── app/           # App configuration & providers
├── core/          # Shared models, utils, widgets  
├── data/          # Repositories & local storage
└── features/      # Dashboard, transactions, budgets
🛠️ Tech Stack
State Management: Riverpod

Local Database: Hive

UI Framework: Flutter Material 3

Charts: FL Chart

State Management
Riverpod provides type-safe, reactive state management with automatic UI updates.

Data Models
Transaction: Income/expense records with categories

Budget: Monthly spending limits per category

UI Components
Dashboard: Financial overview with charts

Transaction Management: Add/edit/delete transactions

Budget Screen: Set and track category budgets

