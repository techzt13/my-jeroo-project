import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MaterialModule } from './material.module';
import { JavaHelpComponent } from './help/java-help/java-help.component';
import { HelpConditionJavaComponent } from './help/java-help/help-condition-java/help-condition-java.component';
import { HelpControlStructJavaComponent } from './help/java-help/help-control-struct-java/help-control-struct-java.component';
import { HelpGeneralJavaComponent } from './help/java-help/help-general-java/help-general-java.component';
import { HelpInstantiationJavaComponent } from './help/java-help/help-instantiation-java/help-instantiation-java.component';
import { HelpMethodJavaComponent } from './help/java-help/help-method-java/help-method-java.component';
import { PythonHelpComponent } from './help/python-help/python-help.component';
import { HelpConditionPythonComponent } from './help/python-help/help-condition-python/help-condition-python.component';
import { HelpControlStructPythonComponent } from './help/python-help/help-control-struct-python/help-control-struct-python.component';
import { HelpGeneralPythonComponent } from './help/python-help/help-general-python/help-general-python.component';
import { HelpInstantiationPythonComponent } from './help/python-help/help-instantiation-python/help-instantiation-python.component';
import { HelpMethodPythonComponent } from './help/python-help/help-method-python/help-method-python.component';
import { VBHelpComponent } from './help/vbhelp/vbhelp.component';
import { HelpConditionVBComponent } from './help/vbhelp/help-condition-vb/help-condition-vb.component';
import { HelpControlStructVBComponent } from './help/vbhelp/help-control-struct-vb/help-control-struct-vb.component';
import { HelpGeneralVbComponent } from './help/vbhelp/help-general-vb/help-general-vb.component';
import { HelpInstantiationVbComponent } from './help/vbhelp/help-instantiation-vb/help-instantiation-vb.component';
import { HelpMethodVbComponent } from './help/vbhelp/help-method-vb/help-method-vb.component';
import { HelpActionComponent } from './help/general/help-action/help-action.component';
import { HelpBooleanComponent } from './help/general/help-boolean/help-boolean.component';
import { HelpCompassComponent } from './help/general/help-compass/help-compass.component';
import { HelpDirectionsComponent } from './help/general/help-directions/help-directions.component';
import { HelpRelativeComponent } from './help/general/help-relative/help-relative.component';
import { HelpTutorialJavaComponent } from './help/tutorial/help-tutorial-java/help-tutorial-java.component';
import { HelpTutorialPythonComponent } from './help/tutorial/help-tutorial-python/help-tutorial-python.component';
import { HelpTutorialVbComponent } from './help/tutorial/help-tutorial-vb/help-tutorial-vb.component';

@NgModule({
    declarations: [
        AppComponent,
        JavaHelpComponent,
        HelpConditionJavaComponent,
        HelpControlStructJavaComponent,
        HelpGeneralJavaComponent,
        HelpInstantiationJavaComponent,
        HelpMethodJavaComponent,
        PythonHelpComponent,
        HelpConditionPythonComponent,
        HelpControlStructPythonComponent,
        HelpGeneralPythonComponent,
        HelpInstantiationPythonComponent,
        HelpMethodPythonComponent,
        VBHelpComponent,
        HelpConditionVBComponent,
        HelpControlStructVBComponent,
        HelpGeneralVbComponent,
        HelpInstantiationVbComponent,
        HelpMethodVbComponent,
        HelpActionComponent,
        HelpBooleanComponent,
        HelpCompassComponent,
        HelpDirectionsComponent,
        HelpRelativeComponent,
        HelpTutorialJavaComponent,
        HelpTutorialPythonComponent,
        HelpTutorialVbComponent
    ],
    imports: [
        BrowserModule,
        AppRoutingModule,
        MaterialModule,
        BrowserAnimationsModule
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule { }
