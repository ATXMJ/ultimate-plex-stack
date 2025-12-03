# Phase 9: Testing and Validation

This final phase performs comprehensive end-to-end testing of your Ultimate Plex Media Stack to ensure all components work together correctly, security is properly implemented, and performance meets expectations.

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **Testing Strategy**: The agent will help design a comprehensive testing plan based on your setup
- **Test Execution**: Step-by-step guidance through each test scenario with result interpretation
- **Issue Diagnosis**: Together you'll identify and resolve any issues discovered during testing
- **Performance Analysis**: Help analyzing test results and optimizing configurations

### What You'll Need to Provide
- **Testing Scenarios**: Your priority test cases (e.g., streaming, downloading, security)
- **Client Devices**: Access to devices for testing different Plex clients
- **Performance Expectations**: Your benchmarks for acceptable performance
- **User Workflows**: Description of how you and others will use the system

### Interactive Process
- **Test Planning**: The agent will help prioritize tests based on your needs and risk areas
- **Result Interpretation**: Together you'll analyze test results and determine pass/fail criteria
- **Iterative Testing**: Re-testing after fixes with the agent's guidance
- **Documentation**: The agent will help document test results and create a final readiness assessment

## Testing Overview

The validation process includes:
- **Functional Testing**: Core features and integrations
- **Performance Testing**: Speed, reliability, and resource usage
- **Security Testing**: Access controls and data protection
- **User Experience Testing**: Real-world usage scenarios
- **Monitoring Setup**: Ongoing health and performance tracking

## Pre-Testing Preparation

### System Health Check
```bash
# Verify all services are running
docker compose --profile core ps

# Check system resources
echo "=== System Resources ==="
free -h
df -h
uptime

# Verify network connectivity
echo "=== Network Status ==="
ping -c 2 8.8.8.8
curl -s https://yourdomain.com | head -1
```

### Test Data Preparation
```bash
# Create test media files for validation
mkdir -p temp/test-media

# Create small test video (if ffmpeg available)
ffmpeg -f lavfi -i testsrc=duration=10:size=320x240:rate=1 -c:v libx264 temp/test-media/test-video.mp4 2>/dev/null || echo "ffmpeg not available - skip video creation"

# Create test audio file
# (Create or download small test files)

# Copy test files to media directories
cp temp/test-media/* media/movies/ 2>/dev/null || true
cp temp/test-media/* media/tv/ 2>/dev/null || true
```

### Test Environment Setup
```bash
# Create test user accounts if needed
# Prepare test API keys
# Set up test client devices
```

## Functional Testing

### Core Service Testing

#### Plex Media Server Validation
```bash
# Test Plex accessibility
curl -I https://plex.yourdomain.com

# Test library scanning
curl -X POST "http://plex:32400/library/sections/all/refresh" \
     -H "X-Plex-Token: YOUR_PLEX_TOKEN"

# Verify test media appears
docker compose --profile core exec plex find /media/ -name "*.mp4" -o -name "*.mkv" | head -5
```

#### Radarr Testing
```bash
# Test Radarr API
curl -s http://localhost:7878/api/v3/system/status | jq .version

# Test movie search and addition
# Manual: Add a test movie via web interface

# Verify download client connectivity
curl -s http://localhost:7878/api/v3/downloadclient | jq '.[].name'
```

#### Sonarr Testing
```bash
# Test Sonarr API
curl -s http://localhost:8989/api/v3/system/status | jq .version

# Test TV show search and addition
# Manual: Add a test TV show via web interface

# Verify download client connectivity
curl -s http://localhost:8989/api/v3/downloadclient | jq '.[].name'
```

#### Prowlarr Testing
```bash
# Test indexer connectivity
curl -s http://localhost:9696/api/v1/indexer | jq length

# Test indexer searches
# Manual: Verify indexers are responding in web interface
```

#### Overseerr Testing
```bash
# Test Overseerr accessibility
curl -I https://overseerr.yourdomain.com

# Test Plex integration
# Manual: Verify media libraries appear in Overseerr
```

### Advanced Services Testing (if deployed)

#### Download Client Testing
```bash
# Test qBittorrent (if deployed)
curl -u admin:password http://localhost:8080/api/v2/app/version

# Test NZBGet (if deployed)
curl -u nzbget:password http://localhost:6789/jsonrpc -d '{"method": "version"}'
```

#### Transcoding Testing
```bash
# Test Tdarr (if deployed)
curl -s http://localhost:8265/api/v1/status | jq .version

# Test transcoding pipeline
# Manual: Add test file to Tdarr library and monitor processing
```

#### Subtitle Testing
```bash
# Test Bazarr (if deployed)
curl -s http://localhost:6767/api/system/status | jq .version

# Manual: Verify subtitle download for test media
```

## End-to-End Pipeline Testing

### Media Acquisition Pipeline
```bash
# Create comprehensive test script
cat > shared/scripts/test-pipeline.sh << 'EOF'
#!/bin/bash
echo "=== Media Acquisition Pipeline Test ==="
echo "Testing complete workflow from request to streaming"

# Test 1: Overseerr Request
echo "1. Testing Overseerr integration..."
# Manual step: Create request in Overseerr

# Test 2: Radarr/Sonarr Processing
echo "2. Testing automation services..."
# Check if services are processing requests

# Test 3: Download Client Activity
echo "3. Testing download clients..."
if docker compose --profile torrent ps qbittorrent | grep -q "Up"; then
    echo "✓ qBittorrent available"
fi

# Test 4: File Import
echo "4. Testing file import..."
# Monitor for completed downloads

# Test 5: Plex Library Update
echo "5. Testing Plex integration..."
# Check if new media appears in Plex

echo "Pipeline test initiated - monitor services manually"
EOF

chmod +x shared/scripts/test-pipeline.sh
./shared/scripts/test-pipeline.sh
```

### Streaming and Playback Testing
```bash
# Test different streaming scenarios
echo "=== Streaming Tests ==="

# Test direct play
# Test transcoding
# Test multiple simultaneous streams
# Test different client types (web, mobile, TV)

# Performance monitoring during streaming
docker stats --no-stream
```

### User Workflow Testing
```bash
# Test complete user workflows:
# 1. User requests media in Overseerr
# 2. Admin approves/denies request
# 3. Media is automatically downloaded
# 4. Media appears in Plex
# 5. User streams content

# Document any issues or friction points
```

## Security Testing

### Access Control Validation
```bash
# Test authentication requirements
echo "=== Security Tests ==="

# Test public access (should be blocked)
curl -s https://radarr.yourdomain.com | grep -i "auth"

# Test authenticated access
curl -u admin:password https://radarr.yourdomain.com/api/v3/system/status

# Test SSL certificate validity
openssl s_client -connect plex.yourdomain.com:443 < /dev/null 2>/dev/null | openssl x509 -noout -dates
```

### Network Security Testing
```bash
# Test VPN functionality (if torrent services deployed)
if docker compose --profile torrent ps wireguard | grep -q "Up"; then
    # Check if torrent traffic is routed through VPN
    docker compose --profile torrent exec qbittorrent curl -s https://ipinfo.io/ip
fi

# Test firewall rules
sudo ufw status

# Test kill switch (if applicable)
# Temporarily disconnect VPN and verify no traffic leaks
```

### Data Protection Testing
```bash
# Verify sensitive data is protected
# Check that API keys are not exposed in logs
# Verify encrypted communications
# Test backup security
```

## Performance Testing

### Benchmarking Script
```bash
# Create performance benchmark
cat > shared/scripts/benchmark.sh << 'EOF'
#!/bin/bash
echo "=== Performance Benchmark ==="
echo "Testing system performance under load"

# CPU/Memory baseline
echo "Baseline resource usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Library scan performance
echo "Library scan test:"
START=$(date +%s)
curl -X POST "http://plex:32400/library/sections/all/refresh" -H "X-Plex-Token: YOUR_PLEX_TOKEN"
sleep 30  # Wait for scan to start
docker stats --no-stream | head -10

# Streaming performance test
echo "Streaming performance:"
# Manual: Start playback and monitor resources

# Download performance (if applicable)
echo "Download performance:"
# Monitor during active downloads

END=$(date +%s)
echo "Benchmark completed in $((END-START)) seconds"
EOF

chmod +x shared/scripts/benchmark.sh
```

### Load Testing
```bash
# Test concurrent access
# Test large library scanning
# Test multiple transcoding jobs
# Test sustained streaming load

# Document performance metrics
MAX_CONCURRENT_STREAMS=5
LIBRARY_SCAN_TIME="X minutes"
TRANSCODE_SPEED="X MB/s"
```

### Resource Usage Analysis
```bash
# Monitor resource usage patterns
# Identify bottlenecks
# Optimize based on findings

# Create resource monitoring baseline
docker system df
du -sh config/ downloads/ transcode/ media/ temp/
```

## User Experience Testing

### Client Compatibility Testing
```bash
# Test with different Plex clients:
# - Web browser
# - Mobile apps (iOS/Android)
# - Smart TV apps
# - Streaming devices (Roku, Fire TV, etc.)
# - Desktop applications

# Document any client-specific issues
```

### Interface Usability Testing
```bash
# Test user interfaces for:
# - Intuitive navigation
# - Clear error messages
# - Responsive design
# - Accessibility features

# Gather user feedback on workflows
```

## Monitoring and Alerting Setup

### Health Monitoring Configuration
```bash
# Set up comprehensive monitoring
cat > shared/scripts/health-monitor.sh << 'EOF'
#!/bin/bash
# Comprehensive health monitoring script

LOG_FILE="temp/logs/health-$(date +%Y%m%d).log"

echo "=== Health Check: $(date) ===" >> "$LOG_FILE"

# Service status
echo "Service Status:" >> "$LOG_FILE"
docker compose --profile core ps --format "table {{.Name}}\t{{.Status}}" >> "$LOG_FILE"

# Resource usage
echo -e "\nResource Usage:" >> "$LOG_FILE"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" >> "$LOG_FILE"

# Storage usage
echo -e "\nStorage Usage:" >> "$LOG_FILE"
df -h | grep -E "(Filesystem|/mnt)" >> "$LOG_FILE"
du -sh config/ downloads/ transcode/ media/ temp/ 2>/dev/null >> "$LOG_FILE"

# Error detection
echo -e "\nRecent Errors:" >> "$LOG_FILE"
docker compose --profile core logs --since "1h" 2>&1 | grep -i error | tail -5 >> "$LOG_FILE"

# Network connectivity
echo -e "\nNetwork Status:" >> "$LOG_FILE"
ping -c 1 8.8.8.8 >/dev/null && echo "✓ Internet connectivity" >> "$LOG_FILE" || echo "✗ No internet" >> "$LOG_FILE"

echo "Health check completed" >> "$LOG_FILE"
EOF

chmod +x shared/scripts/health-monitor.sh
```

### Automated Monitoring
```bash
# Set up cron jobs for regular monitoring
echo "*/30 * * * * /path/to/ultimate-plex-stack/shared/scripts/health-monitor.sh" | crontab -
echo "0 */6 * * * /path/to/ultimate-plex-stack/shared/scripts/security-monitor.sh" | crontab -

# Set up alerts (optional)
# - Email notifications for failures
# - Slack/Discord webhooks
# - SMS alerts for critical issues
```

### Backup Automation
```bash
# Schedule regular backups
echo "0 2 * * * /path/to/ultimate-plex-stack/shared/scripts/backups/backup-config.sh" | crontab -

# Test backup restoration
# Document backup/recovery procedures
```

## Test Results Documentation

### Create Test Report
```bash
# Generate comprehensive test report
cat > temp/test-results-$(date +%Y%m%d).md << 'EOF'
# Ultimate Plex Stack Test Results
Date: $(date)

## Executive Summary
[Overall assessment of system readiness]

## Functional Testing Results

### Core Services
- [ ] Plex Media Server: PASS/FAIL
- [ ] Radarr: PASS/FAIL
- [ ] Sonarr: PASS/FAIL
- [ ] Prowlarr: PASS/FAIL
- [ ] Overseerr: PASS/FAIL

### Advanced Services
- [ ] qBittorrent: PASS/FAIL
- [ ] NZBGet: PASS/FAIL
- [ ] Tdarr: PASS/FAIL
- [ ] Bazarr: PASS/FAIL

### Integration Testing
- [ ] Media acquisition pipeline: PASS/FAIL
- [ ] Streaming functionality: PASS/FAIL
- [ ] User workflows: PASS/FAIL

## Performance Metrics

### System Performance
- CPU Usage: [X]%
- Memory Usage: [X]GB
- Storage Usage: [X]GB
- Network Throughput: [X]MB/s

### Application Performance
- Library scan time: [X] minutes
- Transcoding speed: [X] MB/s
- Concurrent streams supported: [X]

## Security Assessment
- [ ] Authentication working: PASS/FAIL
- [ ] SSL certificates valid: PASS/FAIL
- [ ] VPN protection active: PASS/FAIL
- [ ] Firewall configured: PASS/FAIL

## Issues and Resolutions

### Critical Issues
1. [Issue description]
   - Status: Open/Resolved
   - Resolution: [Details]

### Minor Issues
1. [Issue description]
   - Status: Open/Resolved
   - Resolution: [Details]

## Recommendations
[Future improvements and optimizations]

## Sign-off
Tested by: [Name]
Date: [Date]
EOF

echo "Test results template created: temp/test-results-$(date +%Y%m%d).md"
```

## Final System Validation

### Go-Live Checklist
- [ ] All critical functionality tested and working
- [ ] Performance meets requirements
- [ ] Security measures validated
- [ ] Monitoring and alerting configured
- [ ] Backup procedures tested
- [ ] Documentation complete
- [ ] User training provided (if applicable)
- [ ] Support procedures established

### Production Readiness Assessment
```bash
# Final readiness check
echo "=== Production Readiness Assessment ==="

TOTAL_TESTS=10
PASSED_TESTS=0

# Service availability
if docker compose --profile core ps | grep -q "Up"; then
    echo "✓ Core services running"
    ((PASSED_TESTS++))
fi

# Web access
if curl -s https://plex.yourdomain.com > /dev/null; then
    echo "✓ Web interfaces accessible"
    ((PASSED_TESTS++))
fi

# SSL validation
if openssl s_client -connect plex.yourdomain.com:443 < /dev/null 2>/dev/null | openssl x509 -noout -checkend 604800 > /dev/null; then
    echo "✓ SSL certificates valid"
    ((PASSED_TESTS++))
fi

# Add more automated checks...

READINESS=$((PASSED_TESTS * 100 / TOTAL_TESTS))
echo "System readiness: ${READINESS}% (${PASSED_TESTS}/${TOTAL_TESTS} tests passed)"

if [ $READINESS -ge 90 ]; then
    echo "🎉 System is production ready!"
elif [ $READINESS -ge 75 ]; then
    echo "⚠️  System mostly ready, minor issues to resolve"
else
    echo "❌ System requires additional work before production"
fi
```

## Maintenance and Support

### Ongoing Support Procedures
- Regular health checks
- Performance monitoring
- Security updates
- User support processes
- Backup verification

### Troubleshooting Resources
- Service logs locations
- Common issue solutions
- Support contact information
- Documentation references

## Completion Summary

Congratulations! You have successfully set up and validated the Ultimate Plex Media Stack. Your system includes:

- **Core Media Services**: Plex, Radarr, Sonarr, Prowlarr, Overseerr
- **Content Acquisition**: Torrent and/or Usenet downloading with VPN protection
- **Media Processing**: Automated transcoding and subtitle management
- **Security**: SSL encryption, authentication, and network protection
- **Storage**: Optimized hybrid local/NAS storage architecture
- **Monitoring**: Automated health checks and performance monitoring

### Next Steps
1. Begin using your media server
2. Set up user accounts and permissions
3. Configure additional content libraries
4. Monitor system performance and usage
5. Plan for future expansions and updates

### Support and Resources
- Check service logs: `docker compose logs <service>`
- Health monitoring: `./shared/scripts/health-monitor.sh`
- Backup procedures: `./shared/scripts/backups/backup-config.sh`
- Documentation: Refer to SETUP.md and individual phase guides

Your Ultimate Plex Media Stack is now ready for production use! Enjoy your automated media management system.
