# ₹1 Lakh Challenge Tracker

A mobile-first public progress journal and private admin dashboard for tracking the December 31, 2026 ₹100,000 challenge.

## Stack
- React + Vite
- Supabase Auth + Postgres (RLS)
- Vercel deployment

## Setup
1. Copy `.env.example` to `.env.local`.
2. Set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` (publishable/anon key).
3. Run `npm install && npm run dev`.
4. Apply `supabase/schema.sql` to the Supabase project.

The public page is read-only. Only authenticated admin users can publish updates or change income totals.
