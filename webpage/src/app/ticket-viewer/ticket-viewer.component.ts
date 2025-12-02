import { Component, OnInit } from '@angular/core';
import { MockDataService, Ticket } from '../mock-data.service';

@Component({
  selector: 'app-ticket-viewer',
  templateUrl: './ticket-viewer.component.html',
  styleUrls: ['./ticket-viewer.component.css']
})
export class TicketViewerComponent implements OnInit {
  tickets: Ticket[] = [];
  filteredTickets: Ticket[] = [];
  currentFilter: string = 'All';

  constructor(private mockDataService: MockDataService) { }

  ngOnInit(): void {
    this.mockDataService.getTickets().subscribe(data => {
      this.tickets = data;
      this.filterTickets('All');
    });
  }

  filterTickets(status: string): void {
    this.currentFilter = status;
    if (status === 'All') {
      this.filteredTickets = this.tickets;
    } else {
      this.filteredTickets = this.tickets.filter(t => t.status === status);
    }
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'Open': return 'bg-green-100 text-green-800';
      case 'In Progress': return 'bg-yellow-100 text-yellow-800';
      case 'Closed': return 'bg-gray-100 text-gray-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  }
}
