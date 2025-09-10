.PHONY: bootstrap dev build test lint clean seed

bootstrap:
	@echo "Setting up development environment..."
	pnpm install
	@echo "Bootstrap complete!"

dev:
	@echo "Starting development servers..."
	pnpm dev

build:
	@echo "Building all applications..."
	pnpm build

test:
	@echo "Running tests..."
	pnpm test

lint:
	@echo "Running linters..."
	pnpm lint

clean:
	@echo "Cleaning build artifacts..."
	pnpm clean

seed:
	@echo "Seeding development data..."
	@echo "TODO: Implement database seeding"