import express, { Express, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { env } from './config/env';
import { contactRouter } from './modules/contact/contact.routes';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';

export function createApp(): Express {
  const app = express();

  app.use(helmet());
  app.use(cors({ origin: env.frontendOrigins }));
  app.use(express.json({ limit: '10kb' }));
  app.use(morgan(env.isProduction ? 'combined' : 'dev'));

  app.get('/health', (_req: Request, res: Response) => {
    res.json({ success: true, data: { status: 'ok' }, message: 'Healthy' });
  });

  app.use('/api/contact', contactRouter);

  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}
