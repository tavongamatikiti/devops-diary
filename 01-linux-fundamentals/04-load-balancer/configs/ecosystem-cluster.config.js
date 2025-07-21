// PM2 Ecosystem Configuration for Load Balanced Environment
module.exports = {
    apps: [{
        name: 'nexus-api',
        script: 'app.js',
        instances: 'max',  // Use all CPU cores
        exec_mode: 'cluster',
        env: {
            NODE_ENV: 'production',
            PORT: 3000
        },
        env_production: {
            NODE_ENV: 'production',
            PORT: 3000,
            DB_HOST: '172.31.23.224',
            DB_NAME: 'nexus_db',
            DB_USER: 'nexus_admin',
            DB_PASSWORD: 'denga123!'
        },
        error_file: './logs/error.log',
        out_file: './logs/out.log',
        log_file: './logs/combined.log',
        time: true,
        max_memory_restart: '1G',
        node_args: '--max-old-space-size=1024',
        watch: false,
        autorestart: true,
        max_restarts: 10,

        // Health check settings
        health_check_grace_period: 5000,
        health_check_delay: 3000
    }]
};
