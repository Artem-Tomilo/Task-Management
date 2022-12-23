//
//  TaskEditViewControllerDelegate.swift
//  trainingtask
//
//  Created by Артем Томило on 12.12.22.
//

import Foundation

protocol TaskEditViewControllerDelegate: AnyObject {
    func addTaskDidCancel(_ controller: TaskEditViewController)
    func addNewTask(_ controller: TaskEditViewController, newTask: Task)
    func editTask(_ controller: TaskEditViewController, editedTask: Task)
}
