import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation'

export default class OrderManagement extends NavigationMixin(LightningElement) {
    @api recordId;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference.state.c__accountId) {
            this.recordId = currentPageReference.state.c__accountId;
        }
    }
}