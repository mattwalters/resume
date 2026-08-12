#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

TEX_FILE="resume.tex"
PDF_FILE="resume.pdf"

echo "Compiling $TEX_FILE..."

if command -v pdflatex >/dev/null 2>&1; then
    echo "Using native pdflatex..."
    pdflatex -interaction=nonstopmode "$TEX_FILE"
elif command -v tectonic >/dev/null 2>&1; then
    echo "Using tectonic..."
    tectonic "$TEX_FILE"
elif command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    echo "pdflatex/tectonic not found natively; compiling via Docker (blang/latex)..."
    docker run --rm -v "$DIR":/data -w /data blang/latex pdflatex -interaction=nonstopmode "$TEX_FILE"
else
    echo "Error: No LaTeX engine found."
    echo "To compile natively, install basictex or tectonic:"
    echo "  brew install --cask basictex"
    echo "  OR"
    echo "  brew install tectonic"
    exit 1
fi

# Clean up auxiliary build files
rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk 2>/dev/null || true

echo "Successfully compiled $PDF_FILE!"
