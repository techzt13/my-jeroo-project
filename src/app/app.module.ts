import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HelpComponent } from './help/help.component';
import { MaterialModule } from './material.module';
import { HelpActionComponent } from './help/general/help-action/help-action.component';
import { HelpBooleanComponent } from './help/general/help-boolean/help-boolean.component';
import { HelpCompassComponent } from './help/general/help-compass/help-compass.component';
import { HelpDirectionsComponent } from './help/general/help-directions/help-directions.component';
import { HelpRelativeComponent } from './help/general/help-relative/help-relative.component';
import { HelpConditionJavaComponent } from './help/java/help-condition-java/help-condition-java.component';
import { HelpControlStructJavaComponent } from './help/java/help-control-struct-java/help-control-struct-java.component';
import { HelpGeneralJavaComponent } from './help/java/help-general-java/help-general-java.component';
import { HelpInstantiationJavaComponent } from './help/java/help-instantiation-java/help-instantiation-java.component';
import { HelpMethodJavaComponent } from './help/java/help-method-java/help-method-java.component';
import { HelpMethodPythonComponent } from './help/Python/help-method-python/help-method-python.component';
import { HelpInstantiationPythonComponent } from './help/python/help-instantiation-python/help-instantiation-python.component';
import { HelpGeneralPythonComponent } from './help/python/help-general-python/help-general-python.component';
import { HelpControlStructPythonComponent } from './help/python/help-control-struct-python/help-control-struct-python.component';
import { HelpConditionPythonComponent } from './help/python/help-condition-python/help-condition-python.component';
import { HelpConditionVBComponent } from './help/vb/help-condition-vb/help-condition-vb.component';
import { HelpControlStructVBComponent } from './help/vb/help-control-struct-vb/help-control-struct-vb.component';
import { HelpGeneralVbComponent } from './help/vb/help-general-vb/help-general-vb.component';
import { HelpInstantiationVbComponent } from './help/vb/help-instantiation-vb/help-instantiation-vb.component';
import { HelpMethodVbComponent } from './help/vb/help-method-vb/help-method-vb.component';
import { HelpTutorialVbComponent } from './help/tutorial/help-tutorial-vb/help-tutorial-vb.component';
import { HelpTutorialJavaComponent } from './help/tutorial/help-tutorial-java/help-tutorial-java.component';
import { HelpTutorialPythonComponent } from './help/tutorial/help-tutorial-python/help-tutorial-python.component';
 

@NgModule({
  declarations: [
    AppComponent,
    HelpComponent,
    HelpActionComponent,
    HelpBooleanComponent,
    HelpCompassComponent,
    HelpDirectionsComponent,
    HelpRelativeComponent,
    HelpConditionJavaComponent,
    HelpControlStructJavaComponent,
    HelpGeneralJavaComponent,
    HelpInstantiationJavaComponent,
    HelpMethodJavaComponent,
    HelpMethodPythonComponent,
    HelpInstantiationPythonComponent,
    HelpGeneralPythonComponent,
    HelpControlStructPythonComponent,
    HelpConditionPythonComponent,
    HelpConditionVBComponent,
    HelpControlStructVBComponent,
    HelpGeneralVbComponent,
    HelpInstantiationVbComponent,
    HelpMethodVbComponent,
    HelpTutorialVbComponent,
    HelpTutorialJavaComponent,
    HelpTutorialPythonComponent
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
