//
//  ProjectEditViewControllerDelegate.swift
//  trainingtask
//
//  Created by Артем Томило on 9.12.22.
//

import Foundation

protocol ProjectEditViewControllerDelegate: AnyObject {
    func addProjectDidCancel(_ controller: ProjectEditViewController)
    func addNewProject(_ controller: ProjectEditViewController, newProjecr: Project)
    func editProject(_ controller: ProjectEditViewController, editedProject: Project)
}
