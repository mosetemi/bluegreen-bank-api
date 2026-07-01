"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var express_1 = require("express");
var app = (0, express_1.default)();
var port = 3000;
var VERSION = process.env.APP_VERSION || 'v1';
var COLOR = process.env.DEPLOY_COLOR || 'blue';
app.get('/health', function (req, res) {
    res.json({ status: 'ok', version: VERSION, color: COLOR, timestamp: new Date().toISOString() });
});
app.get('/transactions', function (req, res) {
    // Sample transactions data
    res.json({ version: VERSION, color: COLOR, transactions: [
            { id: 1, amount: 100, currency: 'USD', date: '2024-06-01' },
            { id: 2, amount: 200, currency: 'EUR', date: '2024-06-02' },
            { id: 3, amount: 300, currency: 'GBP', date: '2024-06-03' }
        ] });
});
app.listen(port, function () {
    console.log("BlueGreen Bank API version: ".concat(VERSION, " color: ").concat(COLOR, " listening at http://localhost:").concat(port));
});
