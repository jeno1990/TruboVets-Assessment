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

  insertText(prefix: string, suffix: string = ''): void {
    const textarea = document.querySelector('textarea') as HTMLTextAreaElement;
    if (!textarea) return;

    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const text = this.content;
    const before = text.substring(0, start);
    const selection = text.substring(start, end);
    const after = text.substring(end);

    this.content = `${before}${prefix}${selection}${suffix}${after}`;
    
    // Restore focus and selection
    setTimeout(() => {
      textarea.focus();
      textarea.setSelectionRange(start + prefix.length, end + prefix.length);
    }, 0);
  }
}
