#!/bin/bash

# A2A Examples Runner Script
# This script simplifies running the A2A server and testing agents

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if dependencies are installed
check_dependencies() {
    print_info "Checking dependencies..."
    
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is not installed or not in PATH"
        exit 1
    fi
    
    # Check if pip is available
    if ! python3 -m pip --version &> /dev/null; then
        print_error "pip is not available"
        exit 1
    fi
    
    print_success "Dependencies check passed"
}

# Function to install Python packages
install_packages() {
    print_info "Installing Python packages..."
    python3 -m pip install -e .
    print_success "Packages installed successfully"
}

# Function to run tests
run_tests() {
    print_info "Running tests..."
    if command -v pytest &> /dev/null; then
        python3 -m pytest tests/ -v
    else
        print_warning "pytest not found, installing..."
        python3 -m pip install pytest
        python3 -m pytest tests/ -v
    fi
    print_success "Tests completed"
}

# Function to run the local agent test
run_local_test() {
    print_info "Running local agent test..."
    python3 main.py
    print_success "Local agent test completed"
}

# Function to start the A2A server
start_server() {
    local host=${1:-localhost}
    local port=${2:-10020}
    
    print_info "Starting A2A server on $host:$port..."
    print_info "Press Ctrl+C to stop the server"
    python3 __main__.py --host "$host" --port "$port"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  setup                   Check dependencies and install packages"
    echo "  test                    Run tests"
    echo "  local                   Run local agent test"
    echo "  server [host] [port]    Start A2A server (default: localhost:10020)"
    echo "  all                     Run setup, tests, local test, then start server"
    echo "  help                    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 setup               # Install dependencies"
    echo "  $0 test                # Run tests"
    echo "  $0 local               # Test agents locally"
    echo "  $0 server              # Start server on localhost:10020"
    echo "  $0 server 0.0.0.0 8080 # Start server on 0.0.0.0:8080"
    echo "  $0 all                 # Complete setup and run everything"
}

# Main script logic
main() {
    case "${1:-help}" in
        setup)
            check_dependencies
            install_packages
            ;;
        test)
            run_tests
            ;;
        local)
            run_local_test
            ;;
        server)
            start_server "$2" "$3"
            ;;
        all)
            check_dependencies
            install_packages
            run_tests
            run_local_test
            echo ""
            print_info "All checks passed! Starting server..."
            start_server "$2" "$3"
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
