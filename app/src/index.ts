import express, { Request, Response } from 'express';
const app = express();
const port = 3000;
const VERSION = process.env.APP_VERSION || 'v1';
const COLOR = process.env.DEPLOY_COLOR || 'blue';

app.get('/health', (req: Request, res: Response) => {
    res.json({ status: 'ok', version: VERSION, color: COLOR, timestamp: new Date().toISOString() });
});

app.get('/transactions', (req: Request, res: Response) => {
    // Sample transactions data
    res.json({ version: VERSION, color: COLOR, transactions: [
        {id: 1, amount: 100, currency: 'USD', date: '2024-06-01'},
        {id: 2, amount: 200, currency: 'EUR', date: '2024-06-02'},
        {id: 3, amount: 300, currency: 'GBP', date: '2024-06-03'}
    ]});
});

app.listen(port, () => {
  console.log(`BlueGreen Bank API version: ${VERSION} color: ${COLOR} listening at http://localhost:${port}`);
});
