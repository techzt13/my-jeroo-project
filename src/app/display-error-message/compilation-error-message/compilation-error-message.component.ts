import { Component, Input } from '@angular/core';
import { CodeService } from 'src/app/code.service';

@Component({
  selector: 'app-compilation-error-message',
  templateUrl: './compilation-error-message.component.html'
})
export class CompilationErrorMessageComponent {
  @Input()
  error: CompilationError;

  constructor(private codeService: CodeService) { }

  onPositionLinkClick(e: MouseEvent) {
    e.preventDefault();
    this.codeService.setCursorPosition({
      lnum: this.error.lnum,
      cnum: this.error.cnum,
      pane: this.error.pane
    });
  }
}
