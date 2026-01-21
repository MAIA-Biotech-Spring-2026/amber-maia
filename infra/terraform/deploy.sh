#!/bin/bash
set -e

echo "🚀 Deploying Amber to GCP..."

# Check if terraform.tfvars exists
if [ ! -f terraform.tfvars ]; then
    echo "❌ terraform.tfvars not found. Run setup.sh first."
    exit 1
fi

# Get project ID from terraform.tfvars
PROJECT_ID=$(grep project_id terraform.tfvars | cut -d '"' -f 2)

if [ -z "$PROJECT_ID" ]; then
    echo "❌ Could not find project_id in terraform.tfvars"
    exit 1
fi

echo "📋 Using project: $PROJECT_ID"

# Build and push Docker image
echo "🐳 Building Docker image..."
cd ../..
gcloud builds submit --config=infra/cloudbuild.yaml --project=$PROJECT_ID

# Apply Terraform
echo "🏗️  Applying Terraform configuration..."
cd infra/terraform
terraform apply -auto-approve

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Get your service URL:"
echo "terraform output cloud_run_url"

