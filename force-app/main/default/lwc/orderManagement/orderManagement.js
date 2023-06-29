import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation'

export default class OrderManagement extends NavigationMixin(LightningElement) {
    @api recordId;
    @api refRecordId;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference.state.c__refRecordId) {
            this.refRecordId = currentPageReference.state.c__refRecordId;
        }
    }
}