using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestTargetMove : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 5.33f;
    [SerializeField] private float sprintSpeed = 12.0f;
    
    private CharacterController controller;

    private float vertical = 0.0f;
    private float jumpDelta = 0.0f;
    
    private void Awake()
    {
        controller = GetComponent<CharacterController>();   
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F2))
        {
            SetTarget();
        }

        if (controller.isGrounded)
        {
            if (vertical < 0.0f)
            {
                vertical = -2.0f;
            }

            if(Input.GetKeyDown(KeyCode.Space) && jumpDelta < 0.0f)
            {
                vertical = Mathf.Sqrt(2 * 1.2f * 15.0f);
                jumpDelta = 0.5f;
            }
        }
        else
        {
            vertical -= 15.0f * Time.deltaTime;
        }
 
        jumpDelta -= Time.deltaTime;

        float x = Input.GetAxis("Horizontal");
        float y = Input.GetAxis("Vertical");
        bool sprint = Input.GetKey(KeyCode.LeftShift);

        Vector2 input = new Vector3(x, y).normalized;
        
        Vector3 camForward = Camera.main.transform.forward;
        camForward.y = 0.0f;
        
        Vector3 camRight = Camera.main.transform.right;
        camRight.y = 0.0f;

        Vector3 dir = input.y * camForward + input.x * camRight;
        dir.Normalize();

        float speed = sprint ? sprintSpeed : moveSpeed;
        
        if (input != Vector2.zero)
        {
            transform.forward = dir;
        }

        controller.Move(dir * speed * Time.deltaTime + vertical * Vector3.up * Time.deltaTime);
    }

    private void OnApplicationFocus(bool focus)
    {
        Cursor.visible = !focus;
        Cursor.lockState = focus ? CursorLockMode.Locked : CursorLockMode.None;
    }

    public void SetTarget()
    {
        FindObjectOfType<Bear>().Target = transform;
    }
}
