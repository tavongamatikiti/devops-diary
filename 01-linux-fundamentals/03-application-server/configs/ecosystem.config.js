// PM2 Ecosystem Configuration
module.exports = {
    apps: [{
        name: 'nexus-api',
        script: 'app.js',
        instances: 2,
        exec_mode: 'cluster',
        env: {
            NODE_ENV: 'production',
            PORT: 3000
        },
        error_file: './logs/error.log',
        out_file: './logs/out.log',
        log_file: './logs/combined.log',
        time: true,
        max_memory_restart: '1G',
        node_args: '--max-old-space-size=1024',
        watch: false,
        autorestart: true,
        max_restarts: 10
    }]
};
