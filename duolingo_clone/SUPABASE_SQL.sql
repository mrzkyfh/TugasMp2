-- Hanya menambahkan tabel dan policy yang BELUM ADA
-- Aman dijalankan ulang

-- ── TABLE: quiz_level_progress (BARU) ───────────────────────
CREATE TABLE IF NOT EXISTS quiz_level_progress (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id    UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  level_id   INTEGER NOT NULL,
  stars      INTEGER DEFAULT 0,
  completed  BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, level_id)
);

-- ── Update quiz_results: tambah kolom baru jika belum ada ───
ALTER TABLE quiz_results ADD COLUMN IF NOT EXISTS level_id INTEGER;
ALTER TABLE quiz_results ADD COLUMN IF NOT EXISTS stars INTEGER DEFAULT 0;

-- ── INDEX ────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_quiz_level_progress_user_id ON quiz_level_progress(user_id);

-- ── RLS ──────────────────────────────────────────────────────
ALTER TABLE quiz_level_progress ENABLE ROW LEVEL SECURITY;

-- ── POLICIES (hanya untuk tabel BARU) ───────────────────────
CREATE POLICY "quiz_level_select" ON quiz_level_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "quiz_level_insert" ON quiz_level_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "quiz_level_update" ON quiz_level_progress FOR UPDATE USING (auth.uid() = user_id);

-- ── TRIGGER untuk quiz_level_progress ───────────────────────
CREATE TRIGGER trg_quiz_level_progress_updated_at
  BEFORE UPDATE ON quiz_level_progress
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── REALTIME ─────────────────────────────────────────────────
ALTER PUBLICATION supabase_realtime ADD TABLE quiz_level_progress;
