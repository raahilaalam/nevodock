-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_name VARCHAR(255) NOT NULL,
  customer_email VARCHAR(255) NOT NULL,
  customer_phone VARCHAR(20) NOT NULL,
  customer_address TEXT NOT NULL,
  product_title VARCHAR(255) NOT NULL,
  product_price VARCHAR(50) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Products Table
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  icon VARCHAR(10) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  price VARCHAR(50) NOT NULL,
  position INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Admin Sessions Table
CREATE TABLE IF NOT EXISTS admin_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  admin_code VARCHAR(10) NOT NULL,
  last_login TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX idx_products_position ON products(position ASC);
CREATE INDEX idx_orders_email ON orders(customer_email);

-- Enable Row Level Security
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_sessions ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies for orders (public read/write for now)
CREATE POLICY "Allow public insert on orders" ON orders
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow public select on orders" ON orders
  FOR SELECT
  USING (true);

-- Create RLS Policies for products (public read)
CREATE POLICY "Allow public select on products" ON products
  FOR SELECT
  USING (true);

CREATE POLICY "Allow insert on products" ON products
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow update on products" ON products
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow delete on products" ON products
  FOR DELETE
  USING (true);

-- Create RLS Policies for admin_sessions
CREATE POLICY "Allow public insert on admin_sessions" ON admin_sessions
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow public select on admin_sessions" ON admin_sessions
  FOR SELECT
  USING (true);

-- Insert default products
INSERT INTO products (icon, title, description, price, position) VALUES
  ('🧊', 'Nee-Doh Nice Cube', 'Squish this toy like a dream. This is on limited time offer: $10 off', '$30', 0),
  ('🧈', 'Butter Squishy', 'Squish this butter whenever you want.', '$25', 1),
  ('���', 'Dumpling Squishy', 'This soft squishy is on a $10 off sale. Buy it now', '$20', 2),
  ('🎧', 'Over-Ear Headphones', 'Immersive sound with active noise cancellation and 40-hour battery life.', '$199', 3),
  ('📷', '4K Action Camera', 'Capture every moment in stunning 4K with waterproof design and stabilization.', '$349', 4),
  ('🔋', 'Power Bank 20,000mAh', 'Fast charging power bank with multiple ports and LED display.', '$59', 5)
ON CONFLICT DO NOTHING;
