/*
Copyright 2023.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controller

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/reconcile"

	nomadv1 "asytech.com/nomad/api/v1"
)

const jobDirPath = "/tmp/nomadjobs"

// NomadJobReconciler reconciles a NomadJob object
type NomadJobReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

//+kubebuilder:rbac:groups=nomad.asytech.com,resources=nomadjobs,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=nomad.asytech.com,resources=nomadjobs/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=nomad.asytech.com,resources=nomadjobs/finalizers,verbs=update

// Reconcile is part of the main kubernetes reconciliation loop which aims to
// move the current state of the cluster closer to the desired state.
// TODO(user): Modify the Reconcile function to compare the state specified by
// the NomadJob object against the actual cluster state, and then
// perform operations to make the cluster state reflect the state specified by
// the user.
//
// For more details, check Reconcile and its Result here:
// - https://pkg.go.dev/sigs.k8s.io/controller-runtime@v0.16.0/pkg/reconcile
func (r *NomadJobReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	// Fetch the NomadJob instance
	nomadJob := &nomadv1.NomadJob{}

	toDelete := false
	if err := r.Client.Get(ctx, req.NamespacedName, nomadJob); err != nil {
		if errors.IsNotFound(err) {
			toDelete = true
			fmt.Printf("Le job '%s' a été supprimé dans le namespace '%s'\n", nomadJob.Name, nomadJob.Namespace)
			return reconcile.Result{}, nil
		}
		return reconcile.Result{}, err
	}

	// Extract jobHCL from the NomadJob spec
	jobHCL := nomadJob.Spec.JobHCL
	jobName := nomadJob.Spec.JobName
	jobNamespace := nomadJob.Spec.JobNamespace
	fmt.Printf("Le nom du job est : %s\n", jobName)
	fmt.Printf("Le namespace du job est : %s\n", jobNamespace)

	// -------------------
	// La ressource NomadJob a été supprimée
	// -------------------
	if toDelete == true {
		fmt.Printf("Le job '%s' a été supprimé dans le namespace '%s'\n", jobName, jobNamespace)
		// Run 'nomad job stop -purge' command
		cmd := exec.Command("nomad", "job", "stop", "-purge", "-namespace", jobNamespace, jobName)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		err := cmd.Run()
		if err != nil {
			return reconcile.Result{}, err
		}
		return reconcile.Result{}, nil
	}

	// -------------------
	// La ressource NomadJob doit être créée / modifiée
	// -------------------
	fmt.Printf("Le job '%s' a été crée/modifé dans le namespace '%s'\n", jobName, jobNamespace)

	// Write the jobHCL to a temporary file
	jobFilePath := filepath.Join(jobDirPath, jobNamespace, jobName, "job.hcl")
	err := writeJobHCLToFile(jobHCL, jobFilePath)
	if err != nil {
		return reconcile.Result{}, err
	}
	// Run 'nomad run' command
	cmd := exec.Command("nomad", "job", "run", "-namespace", jobNamespace, jobFilePath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		return reconcile.Result{}, err
	}
	return ctrl.Result{}, nil
}

// SetupWithManager sets up the controller with the Manager.
func (r *NomadJobReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&nomadv1.NomadJob{}).
		Complete(r)
}

func writeJobHCLToFile(jobHCL, filePath string) error {
	if err := os.MkdirAll(filepath.Dir(filePath), os.ModePerm); err != nil {
		return err
	}
	file, err := os.Create(filePath)
	if err != nil {
		return err
	}
	defer file.Close()
	_, err = file.WriteString(jobHCL)
	return err
}
