import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { JavaHelpComponent } from './help/java-help/java-help.component';
import { VBHelpComponent } from './help/vbhelp/vbhelp.component';
import { PythonHelpComponent } from './help/python-help/python-help.component';

const routes: Routes = [
    { path: 'help/java', component: JavaHelpComponent },
    { path: 'help/vb', component: VBHelpComponent },
    { path: 'help/python', component: PythonHelpComponent }
];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
})
export class AppRoutingModule { }
