using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class TestScript2 : MonoBehaviour
{
    [Header("Config")]
    [SerializeField] private float moveSpeed = 5f;

    private Rigidbody rb;
    private Vector2 velocity = Vector2.zero;
    public Vector2 inputValue;
    Vector3 moveDir;

    private bool movementDisabled = false;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }

    //private void Start()
    //{
    //    GameEventsManager.Instance.inputEvents.onMovePressed += MovePressed;
    //    GameEventsManager.Instance.playerEvents.onDisablePlayerMovement += DisablePlayerMovement;
    //    GameEventsManager.Instance.playerEvents.onEnablePlayerMovement += EnablePlayerMovement;
    //}

    //private void OnDestroy()
    //{
    //    GameEventsManager.Instance.inputEvents.onMovePressed -= MovePressed;
    //    GameEventsManager.Instance.playerEvents.onDisablePlayerMovement -= DisablePlayerMovement;
    //    GameEventsManager.Instance.playerEvents.onEnablePlayerMovement -= EnablePlayerMovement;
    //}

    private void DisablePlayerMovement()
    {
        movementDisabled = true;
    }

    private void EnablePlayerMovement()
    {
        movementDisabled = false;
    }

    private void MovePressed(Vector2 moveDir)
    {
        velocity = moveDir.normalized * moveSpeed;

        if (movementDisabled)
        {
            velocity = Vector2.zero;
        }
    }

    private void FixedUpdate()
    {
      

    }

    void Update()
    {
       if(Input.GetKeyDown("F"))
        {
            SubmitPressed();
            
        }
    }
   
    private void OnMove(InputValue value)
    {
        inputValue = value.Get<Vector2>();
        moveDir = new Vector3(inputValue.x, moveDir.y, inputValue.y);
    }

    private void OnInteract(InputValue value)
    {

    }
    private void SubmitPressed()
    {

    }


}
