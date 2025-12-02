import { Component, OnInit, OnDestroy, ViewChild, ElementRef, AfterViewChecked } from '@angular/core';
import { MockDataService } from '../mock-data.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-live-logs',
  templateUrl: './live-logs.component.html',
  styleUrls: ['./live-logs.component.css']
})
export class LiveLogsComponent implements OnInit, OnDestroy, AfterViewChecked {
  logs: string[] = [];
  private logSubscription: Subscription | undefined;
  @ViewChild('logContainer') private logContainer!: ElementRef;

  constructor(private mockDataService: MockDataService) { }

  ngOnInit(): void {
    this.logSubscription = this.mockDataService.getLogs().subscribe(log => {
      this.logs.push(log);
      // Keep only last 50 logs to prevent memory issues in long run
      if (this.logs.length > 50) {
        this.logs.shift();
      }
    });
  }

  ngAfterViewChecked(): void {
    this.scrollToBottom();
  }

  scrollToBottom(): void {
    try {
      this.logContainer.nativeElement.scrollTop = this.logContainer.nativeElement.scrollHeight;
    } catch(err) { }
  }

  ngOnDestroy(): void {
    if (this.logSubscription) {
      this.logSubscription.unsubscribe();
    }
  }

  clearLogs(): void {
    this.logs = [];
  }
}
