#!/bin/bash
set -e

echo "🚀 Setting up GCP for Amber..."

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud CLI not found. Please install: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform not found. Please install: https://www.terraform.io/downloads"
    exit 1
fi

# Get project ID
if [ -z "$GCP_PROJECT_ID" ]; then
    echo "Enter your GCP Project ID:"
    read GCP_PROJECT_ID
fi

echo "📋 Using project: $GCP_PROJECT_ID"
gcloud config set project $GCP_PROJECT_ID

# Enable required APIs
echo "🔌 Enabling required GCP APIs..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable storage-api.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable compute.googleapis.com

echo "✅ APIs enabled"

# Authenticate for application-default credentials
echo "🔐 Setting up authentication..."
gcloud auth application-default login

# Create terraform.tfvars if it doesn't exist
if [ ! -f terraform.tfvars ]; then
    echo "📝 Creating terraform.tfvars..."
    cat > terraform.tfvars <<EOF
project_id  = "$GCP_PROJECT_ID"
region      = "us-central1"
db_password = "$(openssl rand -base64 32)"
EOF
    echo "✅ Created terraform.tfvars with generated password"
    echo "⚠️  Save the db_password from terraform.tfvars securely!"
else
    echo "✅ terraform.tfvars already exists"
fi

# Initialize Terraform
echo "🏗️  Initializing Terraform..."
terraform init

echo ""
echo "✅ GCP setup complete!"
echo ""
echo "Next steps:"
echo "1. Review terraform.tfvars and update if needed"
echo "2. Run: terraform plan"
echo "3. Run: terraform apply"
echo ""
echo "To build and deploy the app:"
echo "1. cd ../../services/app"
echo "2. gcloud builds submit --tag gcr.io/$GCP_PROJECT_ID/amber-app:latest"


