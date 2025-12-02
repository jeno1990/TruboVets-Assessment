import { Injectable } from '@angular/core';
import { Observable, of, interval } from 'rxjs';
import { map } from 'rxjs/operators';

export interface Ticket {
  id: string;
  subject: string;
  status: 'Open' | 'In Progress' | 'Closed';
  createdAt: Date;
}

@Injectable({
  providedIn: 'root'
})
export class MockDataService {
  private tickets: Ticket[] = [
    { id: 'T-101', subject: 'Login failure on iOS', status: 'Open', createdAt: new Date('2023-10-26T10:00:00') },
    { id: 'T-102', subject: 'Dashboard not loading', status: 'In Progress', createdAt: new Date('2023-10-25T14:30:00') },
    { id: 'T-103', subject: 'Password reset email missing', status: 'Closed', createdAt: new Date('2023-10-24T09:15:00') },
    { id: 'T-104', subject: 'Feature request: Dark mode', status: 'Open', createdAt: new Date('2023-10-27T11:20:00') },
    { id: 'T-105', subject: 'Typo in settings menu', status: 'Closed', createdAt: new Date('2023-10-23T16:45:00') },
  ];

  constructor() { }

  getTickets(): Observable<Ticket[]> {
    return of(this.tickets);
  }

  getLogs(): Observable<string> {
    const logMessages = [
      'User logged in',
      'API request failed: 500',
      'Database backup started',
      'New ticket created',
      'Payment processed',
      'Cache cleared',
      'User updated profile'
    ];
    return interval(2000).pipe(
      map(() => {
        const msg = logMessages[Math.floor(Math.random() * logMessages.length)];
        return `[${new Date().toLocaleTimeString()}] ${msg}`;
      })
    );
  }
}
