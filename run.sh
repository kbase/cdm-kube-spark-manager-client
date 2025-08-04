#!/bin/bash
# Exit immediately if a command fails
set -e

# --- Configuration ---
REPO_URL="https://github.com/kbase/cdm-kube-spark-manager.git"
TARGET_DIR="temp_repo_clone"
VENV_DIR="temp_venv"
PYTHON_SPEC_GENERATOR="generate_spec_from_local.py"

# Define where the spec file is temporarily created
INTERMEDIATE_SPEC_DIR="temp_spec"
INTERMEDIATE_SPEC_FILE="$INTERMEDIATE_SPEC_DIR/openapi.json"

# Define where the final client code will be generated
CLIENT_OUTPUT_DIR="src/spark_manager_client"

# --- Main Workflow ---
echo "🚀 --- Starting Full Client Generation Workflow --- 🚀"

# 1. Clean up artifacts from any previous run
echo "🧹 Cleaning up old directories..."
rm -rf "$TARGET_DIR" "$VENV_DIR" "$CLIENT_OUTPUT_DIR" "$INTERMEDIATE_SPEC_DIR"

# 2. Git clone the target repository
echo "📥 Cloning $REPO_URL..."
git clone --depth 1 "$REPO_URL" "$TARGET_DIR"

# 3. Create a virtual environment and install dependencies using uv
echo "🐍 Setting up environment with uv..."
uv venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

echo "📦 Installing project dependencies from pyproject.toml..."
uv pip install -e "$TARGET_DIR"

echo "📦 Installing our generator tools..."
uv pip install "openapi-python-client"

# 4. Run the Python script to generate the spec file
echo "✨ Generating intermediate OpenAPI spec file..."
# THIS IS THE UPDATED LINE:
# We now pass the output path explicitly to the Python script.
python "$PYTHON_SPEC_GENERATOR" "$TARGET_DIR" --output "$INTERMEDIATE_SPEC_FILE"

# 5. Generate the Python client from the spec file
echo "🤖 Generating Python client code..."
openapi-python-client generate --path "$INTERMEDIATE_SPEC_FILE" \
                               --output-path "$CLIENT_OUTPUT_DIR" \
                               --meta none

# 6. Clean up the temporary files and environment
echo "🧹 Cleaning up temporary files and environment..."
deactivate
rm -rf "$TARGET_DIR" "$VENV_DIR" "$INTERMEDIATE_SPEC_DIR"

echo
echo "✅ --- Client Generation Complete! You can now commit the 'src' directory. ---"