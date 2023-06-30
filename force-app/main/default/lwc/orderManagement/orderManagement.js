import { LightningElement, api, wire, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import initData from '@salesforce/apex/OrderManagementController.getInitData';
import createProduct from '@salesforce/apex/OrderManagementController.createProduct';
import PRODUCT_OBJECT from '@salesforce/schema/Product__c';
import NAME_FIELD from '@salesforce/schema/Product__c.Name';
import TYPE_FIELD from '@salesforce/schema/Product__c.Type__c';
import FAMILY_FIELD from '@salesforce/schema/Product__c.Family__c';
import IMAGE_FIELD from '@salesforce/schema/Product__c.Image__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Product__c.Description__c';

export default class OrderManagement extends NavigationMixin(LightningElement) {
    productObject = PRODUCT_OBJECT;
    nameField = NAME_FIELD;
    typeField = TYPE_FIELD;
    familyField = FAMILY_FIELD;
    imageField = IMAGE_FIELD;
    descriptionField = DESCRIPTION_FIELD;
    @api refRecordId;
    @track account;
    @track isManager;
    @track isModalOpen = false;

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

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    createProduct() {
        this.isModalOpen = false;
    }
}