using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class BearLocomotionBehaviour : StateMachineBehaviour
{
    private Bear bear;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        bear = animator.GetComponent<Bear>();
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    //override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    //override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}
    Vector3 p1;
    Vector3 p2;
    // OnStateMove is called right after Animator.OnAnimatorMove()
    override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.transform.position += animator.deltaPosition;
        animator.transform.rotation *= animator.deltaRotation;

        //Vector3 origin = animator.transform.position;

        ////int groundLayerIndex = LayerMask.NameToLayer("Ground");
        ////int layerMask = (1 << groundLayerIndex);

        //RaycastHit slopeHit;

        //if (Physics.Raycast(origin + Vector3.up, Vector3.down, out slopeHit, 100.0f, bear.GroundLayer))
        //{
        //    Debug.DrawLine(origin + Vector3.up, slopeHit.point, Color.red);
        //    Quaternion targetRot = Quaternion.FromToRotation(bear.transform.up, slopeHit.normal) * bear.transform.rotation;
        //    bear.transform.rotation = Quaternion.Lerp(bear.transform.rotation, targetRot, Time.deltaTime * 10.0f);
        //}

        if (Physics.Raycast(animator.transform.position + animator.transform.forward * 1.2f + Vector3.up, Vector3.down, out RaycastHit frontRightHit2, Mathf.Infinity, bear.GroundLayer))
        {
            p1 = frontRightHit2.point;
        }

        if (Physics.Raycast(animator.transform.position + Vector3.up, Vector3.down, out RaycastHit rearLeftHit2, Mathf.Infinity, bear.GroundLayer))
        {
            p2 = rearLeftHit2.point;
        }

        Vector3 forward = animator.transform.forward;
        forward.y = 0;
        forward.Normalize();

        float deltaX = Vector3.Dot(forward, p1 - p2);
        float deltaY = p1.y - p2.y;
        float pitch = Mathf.Atan2(deltaY, deltaX) * Mathf.Rad2Deg;
        animator.transform.rotation = Quaternion.Slerp(animator.transform.rotation, Quaternion.Euler(-pitch, animator.transform.rotation.eulerAngles.y, 0), 10.0f * Time.deltaTime);
    }

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
