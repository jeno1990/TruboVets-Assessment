import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { SidebarComponent } from './sidebar/sidebar.component';
import { TicketViewerComponent } from './ticket-viewer/ticket-viewer.component';
import { KnowledgebaseComponent } from './knowledgebase/knowledgebase.component';
import { LiveLogsComponent } from './live-logs/live-logs.component';

@NgModule({
  declarations: [
    AppComponent,
    SidebarComponent,
    TicketViewerComponent,
    KnowledgebaseComponent,
    LiveLogsComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
