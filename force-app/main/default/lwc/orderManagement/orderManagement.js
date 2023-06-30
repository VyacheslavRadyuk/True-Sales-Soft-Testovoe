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
    nameFieldValue;
    typeField = TYPE_FIELD;
    typeFieldValue;
    familyField = FAMILY_FIELD;
    familyFieldValue
    imageField = IMAGE_FIELD;
    imageFieldValue;
    descriptionField = DESCRIPTION_FIELD;
    descriptionFieldValue;
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
        createProduct({productName: this.nameFieldValue, productType: this.typeFieldValue, productDescription: this.descriptionFieldValue, productFamily: this.familyFieldValue, productImage: this.imageFieldValue})
        .then(result => {
        })
        .catch(error => {
            this.error = error;
            console.error(error.body.message);
        });
        this.nameFieldValue = '';
        this.typeFieldValue = '';
        this.familyFieldValue = '';
        this.descriptionFieldValue = '';
        this.imageFieldValue = '';
        this.isModalOpen = false;
    }

    handleChangeFieldName(event) {
        this.nameFieldValue = event.target.value;
    }

    handleChangeFieldType(event) {
        this.typeFieldValue = event.target.value;
    }

    handleChangeFieldFamily(event) {
        this.familyFieldValue = event.target.value;
    }

    handleChangeFieldImage(event) {
        this.imageFieldValue = event.target.value;
    }

    handleChangeFieldDescription(event) {
        this.descriptionFieldValue = event.target.value;
    }
}