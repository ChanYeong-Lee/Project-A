using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class HorseController : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 3.0f;
    [SerializeField] private float sprintSpeed = 15.0f;
    [SerializeField] private float startAccel = 6.0f;
    [SerializeField] private float decelation = 60.0f;
    [SerializeField] private float jumpHeight;
    [SerializeField] private float rotateSpeed = 45.0f;

    private float accelation = 0.0f;
    private float velocity = 0.0f;
    //private float gravity = 15.0f;

    private bool isGround;

    private Vector2 moveDir = Vector2.zero;
    private Vector3 horizontalMove = Vector3.zero;

    private Rigidbody rb;
    [SerializeField] private Renderer horseRenderer;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }

    private void Update()
    {
        CheckGround();

    }

    private void FixedUpdate()
    {
        float x = Input.GetAxisRaw("Horizontal");
        float y = Input.GetAxisRaw("Vertical");
        bool sprint = Input.GetKey(KeyCode.LeftShift);
        bool aim = Input.GetMouseButton(1);

        Vector3 inputDir = new Vector3(x, 0, y).normalized;
        Vector3 camDir = Camera.main.transform.TransformVector(inputDir);
        camDir.y = 0;
        camDir.Normalize();
        if(!aim) moveDir = new Vector2(camDir.x, camDir.z);
        //Vector2 moveDir = new Vector2(inputDir.x, inputDir.z);

        float angleCoefficient = 1 - Vector2.Angle(new Vector2(transform.forward.x, transform.forward.z), moveDir) / 180.0f;
        accelation = startAccel * (1 + Mathf.Cos((Mathf.PI * velocity) / (2 * (sprintSpeed)) + Mathf.PI / 2));

        if (moveDir != Vector2.zero && isGround)
        {
            velocity += accelation * Time.deltaTime;
        }
        else
        {
            velocity -= decelation * Time.deltaTime;
        }

        velocity = Mathf.Clamp(velocity, 0, sprint ? 15.0f : moveSpeed);

        float velocityCoefficient = (1 - velocity / sprintSpeed) * 0.5f + 0.5f;
        print($"vel = {velocity} accel = {accelation}");
        float inputAngle = Mathf.Atan2(moveDir.x, moveDir.y) * Mathf.Rad2Deg;
        float rotation = 0.0f;
        
        if (180.0f < transform.rotation.eulerAngles.y && transform.rotation.eulerAngles.y < 360.0f)
        {
            rotation = transform.rotation.eulerAngles.y - 360.0f;
        }
        else
        {
            rotation = transform.rotation.eulerAngles.y;
        }

        float rotationDelta = inputAngle - rotation;

        if (Mathf.Abs(rotationDelta) > 5.0f && moveDir != Vector2.zero)
        {
            if (0.0f < rotationDelta && rotationDelta < 180.0f || rotationDelta < -180.0f)
            {
                rb.rotation *= Quaternion.Euler(0, rotateSpeed * velocityCoefficient * Time.deltaTime, 0);
            }
            else
            {
                rb.rotation *= Quaternion.Euler(0, -rotateSpeed * velocityCoefficient * Time.deltaTime, 0);
            }
        }

        rb.MovePosition(rb.position + velocity * transform.forward * Time.deltaTime);
    }


    private void CheckGround()
    {
        isGround = Physics.CheckBox(transform.position, transform.right * 0.8f + transform.up * 0.24f + transform.forward * 0.8f);
    }

    private void JumpAndGravity()
    {

    }

    private void OnDrawGizmos()
    {
        Color tmp = Gizmos.color;

        Gizmos.color = Color.magenta;
        Gizmos.DrawWireCube(transform.position, transform.right * 0.8f + transform.up * 0.15f + transform.forward * 0.8f);
        Gizmos.color = tmp;
    }
    private void OnApplicationFocus(bool focus)
    {
        Cursor.visible = !focus;
        Cursor.lockState = focus ? CursorLockMode.Locked : CursorLockMode.None;
    }

}
