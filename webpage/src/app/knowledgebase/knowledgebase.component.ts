import { Component } from '@angular/core';

@Component({
  selector: 'app-knowledgebase',
  templateUrl: './knowledgebase.component.html',
  styleUrls: ['./knowledgebase.component.css']
})
export class KnowledgebaseComponent {
  content: string = '# Welcome to the Knowledgebase\n\nStart editing this document...';
  isPreviewMode: boolean = false;
  lastSaved: Date | null = null;

  togglePreview(): void {
    this.isPreviewMode = !this.isPreviewMode;
  }

  save(): void {
    // Simulate save
    console.log('Saving content:', this.content);
    this.lastSaved = new Date();
    setTimeout(() => {
      // Clear "saved" message after 3 seconds if desired, or just leave it
    }, 3000);
  }
}
