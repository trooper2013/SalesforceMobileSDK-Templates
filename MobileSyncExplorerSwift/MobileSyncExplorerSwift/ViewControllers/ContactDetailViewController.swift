/*
 ContactDetailViewController.swift
 MobileSyncExplorerSwift
 
 Created by Nicholas McDonald on 1/22/18.
 
 Copyright (c) 2018-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import SmartStore.SFSmartStoreInspectorViewController

protocol ContactDetailViewDelegate {
    func userDidDelete(object: SObjectData)
    func userDidUndelete(object: SObjectData)
    func userDidUpdate(object: SObjectData)
    func userDidAdd(object: SObjectData)
}

class ContactDetailViewController: UniversalViewController {
    typealias ContactDetailEditCompletion = () -> Void
    fileprivate var isNewContact: Bool = false
    fileprivate var isEditingContact: Bool = false
    fileprivate var isContactUpdated: Bool = false
    fileprivate var contact: ContactSObjectData?
    fileprivate var completion: ContactDetailEditCompletion?
    fileprivate var firstNameField: UITextField!
    fileprivate var lastNameField: UITextField!
    fileprivate var mobilePhoneField: UITextField!
    fileprivate var homePhoneField: UITextField!
    fileprivate var jobTitleField: UITextField!
    fileprivate var emailField: UITextField!
    fileprivate var departmentField: UITextField!
    var detailViewDelegate: ContactDetailViewDelegate?
    var objectManager: SObjectDataManager
    
    init(_ contact: ContactSObjectData?, objectManager: SObjectDataManager, completion:ContactDetailEditCompletion?) {
        self.completion = completion
        self.objectManager = objectManager
        super.init(nibName: nil, bundle: nil)
        if let c = contact {
            self.title = ContactHelper.nameStringFromContact(c)
            self.contact = contact
        } else {
            self.title = "New Contact"
            self.isNewContact = true
            self.contact = contact
            self.contact = ContactSObjectData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.detailViewControllerBackground
        let back = self.backBarButton()
        self.navigationItem.leftBarButtonItem = back
        let edit = self.editBarButton()
        self.navigationItem.rightBarButtonItem = edit
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let firstNameLabel = self.fieldLabel("First Name")
        self.firstNameField = self.field(self.contact?.firstName)
        let lastNameLabel = self.fieldLabel("Last Name")
        self.lastNameField = self.field(self.contact?.lastName)
        let mobilePhoneLabel = self.fieldLabel("Mobile Phone")
        self.mobilePhoneField = self.field(self.contact?.mobilePhone)
        let homePhoneLabel = self.fieldLabel("Home Phone")
        self.homePhoneField = self.field(self.contact?.homePhone)
        let jobTitleLabel = self.fieldLabel("Job Title")
        self.jobTitleField = self.field(self.contact?.title)
        let emailLabel = self.fieldLabel("Email Address")
        self.emailField = self.field(self.contact?.email)
        let departmentLabel = self.fieldLabel("Department")
        self.departmentField = self.field(self.contact?.department)
        let deleteButton = self.deleteButton()
        self.firstNameField.autocorrectionType = .no
        self.lastNameField.autocorrectionType = .no
        self.emailField.autocorrectionType = .no
        self.emailField.autocapitalizationType = .none
        self.view.addSubview(scrollView)
        scrollView.addSubview(firstNameLabel)
        scrollView.addSubview(self.firstNameField)
        scrollView.addSubview(lastNameLabel)
        scrollView.addSubview(self.lastNameField)
        scrollView.addSubview(mobilePhoneLabel)
        scrollView.addSubview(self.mobilePhoneField)
        scrollView.addSubview(homePhoneLabel)
        scrollView.addSubview(self.homePhoneField)
        scrollView.addSubview(jobTitleLabel)
        scrollView.addSubview(self.jobTitleField)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(self.emailField)
        scrollView.addSubview(departmentLabel)
        scrollView.addSubview(self.departmentField)
        scrollView.addSubview(deleteButton)
        
        let topAnchor = self.view.safeAreaLayoutGuide.topAnchor
        let bottomAnchor = self.view.safeAreaLayoutGuide.bottomAnchor
        let centerXAnchor = self.view.safeAreaLayoutGuide.centerXAnchor
        let rightAnchor = self.view.safeAreaLayoutGuide.rightAnchor
        let leftAnchor = self.view.safeAreaLayoutGuide.leftAnchor
        
        let regInset: CGFloat = 60.0
        let regCenterInset: CGFloat = 12.0
        let regVertSpace: CGFloat = 30.0
        let compInset: CGFloat = 13.0
        let compVertSpace: CGFloat = 16.0
        let interitemSpace: CGFloat = 0.0
        let textFieldHeight: CGFloat = 44.0
        
        self.commonConstraints.append(contentsOf: [scrollView.leftAnchor.constraint(equalTo: leftAnchor),
                                                   scrollView.rightAnchor.constraint(equalTo: rightAnchor),
                                                   scrollView.topAnchor.constraint(equalTo: topAnchor),
                                                   scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                                   self.firstNameField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                                                   self.lastNameField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                                                   self.mobilePhoneField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                                                   self.homePhoneField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                                                   self.jobTitleField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                                                   self.emailField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                                                   self.departmentField.heightAnchor.constraint(equalToConstant: textFieldHeight)])
        
      self.regularConstraints.append(contentsOf: [firstNameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: regInset),
                                                    firstNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: regInset),
                                                    self.firstNameField.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    self.firstNameField.rightAnchor.constraint(equalTo: centerXAnchor, constant: -regCenterInset),
                                                    self.firstNameField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant:interitemSpace),
                                                    lastNameLabel.leftAnchor.constraint(equalTo: scrollView.centerXAnchor, constant:regCenterInset),
                                                    lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.topAnchor),
                                                    self.lastNameField.leftAnchor.constraint(equalTo: lastNameLabel.leftAnchor),
                                                    self.lastNameField.rightAnchor.constraint(equalTo: rightAnchor, constant: -regInset),
                                                    self.lastNameField.topAnchor.constraint(equalTo: self.firstNameField.topAnchor),
                                                    mobilePhoneLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    mobilePhoneLabel.topAnchor.constraint(equalTo: self.firstNameField.bottomAnchor, constant:regVertSpace),
                                                    self.mobilePhoneField.leftAnchor.constraint(equalTo: mobilePhoneLabel.leftAnchor),
                                                    self.mobilePhoneField.rightAnchor.constraint(equalTo: centerXAnchor, constant: -regCenterInset),
                                                    self.mobilePhoneField.topAnchor.constraint(equalTo: mobilePhoneLabel.bottomAnchor, constant:interitemSpace),
                                                    homePhoneLabel.leftAnchor.constraint(equalTo: lastNameLabel.leftAnchor),
                                                    homePhoneLabel.topAnchor.constraint(equalTo: mobilePhoneLabel.topAnchor),
                                                    self.homePhoneField.leftAnchor.constraint(equalTo: homePhoneLabel.leftAnchor),
                                                    self.homePhoneField.rightAnchor.constraint(equalTo: rightAnchor, constant: -regInset),
                                                    self.homePhoneField.topAnchor.constraint(equalTo: homePhoneLabel.bottomAnchor, constant:interitemSpace),
                                                    jobTitleLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    jobTitleLabel.topAnchor.constraint(equalTo: self.mobilePhoneField.bottomAnchor, constant:regVertSpace),
                                                    self.jobTitleField.leftAnchor.constraint(equalTo: jobTitleLabel.leftAnchor),
                                                    self.jobTitleField.rightAnchor.constraint(equalTo: rightAnchor, constant: -regInset),
                                                    self.jobTitleField.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant:interitemSpace),
                                                    emailLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    emailLabel.topAnchor.constraint(equalTo: self.jobTitleField.bottomAnchor, constant:regVertSpace),
                                                    self.emailField.leftAnchor.constraint(equalTo: emailLabel.leftAnchor),
                                                    self.emailField.rightAnchor.constraint(equalTo: rightAnchor, constant: -regInset),
                                                    self.emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant:interitemSpace),
                                                    departmentLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    departmentLabel.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant:regVertSpace),
                                                    self.departmentField.leftAnchor.constraint(equalTo: departmentLabel.leftAnchor),
                                                    self.departmentField.rightAnchor.constraint(equalTo: rightAnchor, constant: -regInset),
                                                    self.departmentField.topAnchor.constraint(equalTo: departmentLabel.bottomAnchor, constant:interitemSpace),
                                                    deleteButton.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    deleteButton.topAnchor.constraint(equalTo: self.departmentField.bottomAnchor, constant:regVertSpace),
                                                    deleteButton.widthAnchor.constraint(equalToConstant: 116.0),
                                                    deleteButton.heightAnchor.constraint(equalToConstant: 32.0)])
        
        self.compactConstraints.append(contentsOf: [firstNameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: compInset),
                                                    firstNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: compInset),
                                                    self.firstNameField.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    self.firstNameField.rightAnchor.constraint(equalTo: rightAnchor, constant:-compInset),
                                                    self.firstNameField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant:interitemSpace),
                                                    lastNameLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    lastNameLabel.topAnchor.constraint(equalTo: self.firstNameField.bottomAnchor, constant:compVertSpace),
                                                    self.lastNameField.leftAnchor.constraint(equalTo: lastNameLabel.leftAnchor),
                                                    self.lastNameField.rightAnchor.constraint(equalTo: rightAnchor, constant:-compInset),
                                                    self.lastNameField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant:interitemSpace),
                                                    mobilePhoneLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    mobilePhoneLabel.topAnchor.constraint(equalTo: self.lastNameField.bottomAnchor, constant:compVertSpace),
                                                    self.mobilePhoneField.leftAnchor.constraint(equalTo: mobilePhoneLabel.leftAnchor),
                                                    self.mobilePhoneField.rightAnchor.constraint(equalTo: rightAnchor, constant:-compInset),
                                                    self.mobilePhoneField.topAnchor.constraint(equalTo: mobilePhoneLabel.bottomAnchor, constant:interitemSpace),
                                                    homePhoneLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    homePhoneLabel.topAnchor.constraint(equalTo: self.mobilePhoneField.bottomAnchor, constant:compVertSpace),
                                                    self.homePhoneField.leftAnchor.constraint(equalTo: homePhoneLabel.leftAnchor),
                                                    self.homePhoneField.rightAnchor.constraint(equalTo: rightAnchor, constant:-compInset),
                                                    self.homePhoneField.topAnchor.constraint(equalTo: homePhoneLabel.bottomAnchor, constant:interitemSpace),
                                                    jobTitleLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    jobTitleLabel.topAnchor.constraint(equalTo: self.homePhoneField.bottomAnchor, constant:compVertSpace),
                                                    self.jobTitleField.leftAnchor.constraint(equalTo: jobTitleLabel.leftAnchor),
                                                    self.jobTitleField.rightAnchor.constraint(equalTo: rightAnchor, constant:-compInset),
                                                    self.jobTitleField.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant:interitemSpace),
                                                    emailLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    emailLabel.topAnchor.constraint(equalTo: self.jobTitleField.bottomAnchor, constant:compVertSpace),
                                                    self.emailField.leftAnchor.constraint(equalTo: emailLabel.leftAnchor),
                                                    self.emailField.rightAnchor.constraint(equalTo: rightAnchor, constant:-compInset),
                                                    self.emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant:interitemSpace),
                                                    departmentLabel.leftAnchor.constraint(equalTo: firstNameLabel.leftAnchor),
                                                    departmentLabel.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant:compVertSpace),
                                                    self.departmentField.leftAnchor.constraint(equalTo: departmentLabel.leftAnchor),
                                                    self.departmentField.rightAnchor.constraint(equalTo: rightAnchor, constant:-compInset),
                                                    self.departmentField.topAnchor.constraint(equalTo: departmentLabel.bottomAnchor, constant:interitemSpace),
                                                    deleteButton.leftAnchor.constraint(equalTo: leftAnchor, constant: compInset),
                                                    deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -compInset),
                                                    deleteButton.topAnchor.constraint(equalTo: self.departmentField.bottomAnchor, constant:compVertSpace),
                                                    deleteButton.heightAnchor.constraint(equalToConstant: 44.0),
                                                    deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -compInset)
            ])
        super.applyConstraints()
        if self.isNewContact {
            self.beginEditingFields()
        }
    }

    @objc func userDidPressBack() {
        self.endEditingFields()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func userDidPressDelete() {
        self.endEditingFields()
        if let c = self.contact {
            self.detailViewDelegate?.userDidDelete(object:  c)
        }
        self.completeEditing()
    }

    @objc func userDidPressUndelete() {
        self.endEditingFields()
        if let c = self.contact {
            detailViewDelegate?.userDidUndelete(object: c)
        }
        self.completeEditing()
    }

    @objc func userDidPressEdit() {
        self.beginEditingFields()
    }

    @objc func userDidPressCancelEdit() {
        self.endEditingFields()
        self.reloadContactDetails()
    }

    @objc func userDidPressSave() {
        self.endEditingFields()
        self.saveFieldsIfRequired()
    }

    fileprivate func saveFieldsIfRequired() {
        var contactUpdated = false
        guard let c = self.contact else {return}
        contactUpdated = contactUpdated || (self.firstNameField.text != c.firstName)
        contactUpdated = contactUpdated || (self.lastNameField.text != c.lastName)
        contactUpdated = contactUpdated || (self.mobilePhoneField.text != c.mobilePhone)
        contactUpdated = contactUpdated || (self.homePhoneField.text != c.homePhone)
        contactUpdated = contactUpdated || (self.jobTitleField.text != c.title)
        contactUpdated = contactUpdated || (self.emailField.text != c.email)
        contactUpdated = contactUpdated || (self.departmentField.text != c.department)
        
        c.firstName = self.firstNameField.text
        c.lastName = self.lastNameField.text
        c.mobilePhone = self.mobilePhoneField.text
        c.homePhone = self.homePhoneField.text
        c.title = self.jobTitleField.text
        c.email = self.emailField.text
        c.department = self.departmentField.text
        
        if (contactUpdated) {
            if let c = self.contact {
                if self.isNewContact {
                    self.detailViewDelegate?.userDidAdd(object: c)
                }else {
                    self.detailViewDelegate?.userDidUpdate(object: c)
                }
            }
            self.completeEditing()
        } else {
            self.reloadContactDetails()
        }
    }
    
    fileprivate func completeEditing() {
        if let c = self.completion {
            c()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func reloadContactDetails() {
        self.firstNameField.text = self.contact?.firstName
        self.lastNameField.text = self.contact?.lastName
        self.mobilePhoneField.text = self.contact?.mobilePhone
        self.homePhoneField.text = self.contact?.homePhone
        self.jobTitleField.text = self.contact?.title
        self.emailField.text = self.contact?.email
        self.departmentField.text = self.contact?.department
    }
    
    fileprivate func beginEditingFields() {
        self.isEditingContact = true
        self.updateViewsForEditingState()
        self.firstNameField.becomeFirstResponder()
    }
    
    fileprivate func endEditingFields() {
        self.isEditingContact = false
        self.updateViewsForEditingState()
    }
    
    fileprivate func updateViewsForEditingState() {
        var style:UITextField.BorderStyle = .none
        var backgroundColor = UIColor.clear
        if self.isEditingContact {
            style = .roundedRect
            backgroundColor = UIColor.detailViewEditingBackground
            
            let cancel = self.cancelEditBarButton()
            self.navigationItem.leftBarButtonItem = cancel
            
            let save = self.saveBarButton()
            self.navigationItem.rightBarButtonItem = save
        } else {
            let back = self.backBarButton()
            self.navigationItem.leftBarButtonItem = back
            
            let edit = self.editBarButton()
            self.navigationItem.rightBarButtonItem = edit
        }
        self.firstNameField.borderStyle = style
        self.firstNameField.backgroundColor = backgroundColor
        self.firstNameField.isUserInteractionEnabled = self.isEditingContact
        self.lastNameField.borderStyle = style
        self.lastNameField.backgroundColor = backgroundColor
        self.lastNameField.isUserInteractionEnabled = self.isEditingContact
        self.mobilePhoneField.borderStyle = style
        self.mobilePhoneField.backgroundColor = backgroundColor
        self.mobilePhoneField.isUserInteractionEnabled = self.isEditingContact
        self.homePhoneField.borderStyle = style
        self.homePhoneField.backgroundColor = backgroundColor
        self.homePhoneField.isUserInteractionEnabled = self.isEditingContact
        self.jobTitleField.borderStyle = style
        self.jobTitleField.backgroundColor = backgroundColor
        self.jobTitleField.isUserInteractionEnabled = self.isEditingContact
        self.emailField.borderStyle = style
        self.emailField.backgroundColor = backgroundColor
        self.emailField.isUserInteractionEnabled = self.isEditingContact
        self.departmentField.borderStyle = style
        self.departmentField.backgroundColor = backgroundColor
        self.departmentField.isUserInteractionEnabled = self.isEditingContact
    }
    
    fileprivate func deleteButton() -> UIButton {
        guard let c = self.contact else { return UIButton()}
        let locallyDeleted = self.objectManager.dataLocallyDeleted(c)
        let deleteButton = UIButton(type: .custom)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.backgroundColor = UIColor.destructiveButton
        deleteButton.setTitle(locallyDeleted ? "Undelete Contact": "Delete Contact", for: .normal)
        if self.traitCollection.horizontalSizeClass == .compact {
            deleteButton.titleLabel?.font = UIFont.appRegularFont(16.0)
        } else {
            deleteButton.titleLabel?.font = UIFont.appRegularFont(12.0)
        }
        
        deleteButton.titleLabel?.textColor = UIColor.white
        deleteButton.addTarget(self, action: locallyDeleted ? #selector(userDidPressUndelete
            ) : #selector(userDidPressDelete), for: .touchUpInside)
        deleteButton.layer.cornerRadius = 3.0
        deleteButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        if self.isNewContact {
            deleteButton.isEnabled = false
            deleteButton.alpha = 0.5
        }
        return deleteButton
    }
    
    fileprivate func backBarButton() -> UIBarButtonItem {
        let backView = UIButton(type: .custom)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.addTarget(self, action: #selector(userDidPressBack), for: .touchUpInside)
        
        let backLabel = UILabel()
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        backLabel.text = "Back"
        backLabel.textColor = UIColor.white
        backLabel.font = UIFont.appRegularFont(17.0)
        backView.addSubview(backLabel)
        
        let backImage = UIImage(named: "backArrow")?.withRenderingMode(.alwaysOriginal)
        let backImageView = UIImageView(image: backImage)
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(backImageView)
        
        backImageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        backImageView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        
        backLabel.leftAnchor.constraint(equalTo: backImageView.rightAnchor, constant: 6).isActive = true
        backLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        backLabel.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        
        let back = UIBarButtonItem(customView: backView)
        return back
    }
    
    fileprivate func editBarButton() -> UIBarButtonItem {
        let editView = UIButton(type: .custom)
        editView.translatesAutoresizingMaskIntoConstraints = false
        editView.addTarget(self, action: #selector(userDidPressEdit), for: .touchUpInside)
        editView.backgroundColor = UIColor(forLightStyle: UIColor.white, darkStyle: UIColor.clear)
        
        editView.layer.cornerRadius = 3.0
        editView.layer.borderColor = UIColor.white.cgColor
        editView.layer.borderWidth = 0.5
        editView.widthAnchor.constraint(equalToConstant: 58.0).isActive = true
        editView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        let editLabel = UILabel()
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        editLabel.text = "Edit"
        editLabel.textColor = UIColor.init(forLightStyle: UIColor.appBlue, darkStyle: UIColor.white)
        editLabel.font = UIFont.appRegularFont(12)
        editView.addSubview(editLabel)
        
        editLabel.centerYAnchor.constraint(equalTo: editView.centerYAnchor).isActive = true
        editLabel.centerXAnchor.constraint(equalTo: editView.centerXAnchor).isActive = true
        
        let edit = UIBarButtonItem(customView: editView)
        return edit
    }
    
    fileprivate func saveBarButton() -> UIBarButtonItem {
        let saveView = UIButton(type: .custom)
        saveView.translatesAutoresizingMaskIntoConstraints = false
        saveView.addTarget(self, action: #selector(userDidPressSave), for: .touchUpInside)
        saveView.backgroundColor = UIColor.appBlue
        saveView.layer.cornerRadius = 3.0
        
        saveView.widthAnchor.constraint(equalToConstant: 58.0).isActive = true
        saveView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        let saveLabel = UILabel()
        saveLabel.translatesAutoresizingMaskIntoConstraints = false
        saveLabel.text = "Save"
        saveLabel.textColor = UIColor.white
        saveLabel.font = UIFont.appRegularFont(12)
        saveView.addSubview(saveLabel)
        
        saveLabel.centerYAnchor.constraint(equalTo: saveView.centerYAnchor).isActive = true
        saveLabel.centerXAnchor.constraint(equalTo: saveView.centerXAnchor).isActive = true
        
        let save = UIBarButtonItem(customView: saveView)
        return save
    }
    
    fileprivate func cancelEditBarButton() -> UIBarButtonItem {
        let cancelView = UIButton(type: .custom)
        cancelView.translatesAutoresizingMaskIntoConstraints = false
        cancelView.setTitle("Cancel", for: .normal)
        cancelView.titleLabel?.font = UIFont.appRegularFont(16.0)
        cancelView.titleLabel?.textColor = UIColor.white
        cancelView.addTarget(self, action: #selector(userDidPressCancelEdit), for: .touchUpInside)
        
        cancelView.widthAnchor.constraint(equalToConstant: 58.0).isActive = true
        cancelView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        let cancel = UIBarButtonItem(customView: cancelView)
        return cancel
    }
    
    fileprivate func fieldLabel(_ text:String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appRegularFont(13)
        label.textColor = UIColor.secondaryLabelText
        label.text = text
        return label
    }
    
    fileprivate func field(_ text:String?) -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.appRegularFont(16)
        field.textColor = UIColor.salesforceLabel
        field.text = text
        field.isUserInteractionEnabled = false
        return field
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
