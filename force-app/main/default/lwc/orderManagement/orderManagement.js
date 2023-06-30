import { LightningElement, api, wire, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import initData from '@salesforce/apex/OrderManagementController.getInitData';
import createProduct from '@salesforce/apex/OrderManagementController.createProduct';

export default class OrderManagement extends NavigationMixin(LightningElement) {
    @api refRecordId;
    @track account;
    @track isManager;

    get isDisabledButton() {
        return !this.isManager;
    }

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference.state.c__refRecordId) {
            this.refRecordId = currentPageReference.state.c__refRecordId;
        }
    }

    @wire(initData, {recordId : '$refRecordId'})  
    wiredInitData({error, data}) {
        if(data) {
            this.account = data.currentAccount;
            this.isManager = data.isManager;

        } else if (error) {
            console.log(error);
        }
    }

    createProduct() {
        
    }
}