db = db.getSiblingDB('neurosketch');

db.createUser({
    user: 'neurosketch_user',
    pwd: 'neurosketch_password',
    roles: [
        {
            role: 'readWrite',
            db: 'neurosketch'
        }
    ]
});

db.createCollection('coaching_sessions');
db.createCollection('emotional_states');
db.createCollection('image_analyses');
db.createCollection('psychological_interpretations');
db.createCollection('agent_decisions');
db.createCollection('care_statuses');