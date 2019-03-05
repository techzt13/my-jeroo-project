import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { VBHelpComponent } from './vbhelp/vbhelp.component';
import { PythonHelpComponent } from './python-help/python-help.component';
import { JavaHelpComponent } from './java-help/java-help.component';

const routes: Routes = [
    {
        path: 'java',
        component: JavaHelpComponent
    },
    {
        path: 'vb',
        component: VBHelpComponent
    },
    {
        path: 'python',
        component: PythonHelpComponent
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class HelpRoutingModule { }
