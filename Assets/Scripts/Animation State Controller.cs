using UnityEngine;
using UnityEngine.Windows;

public class Animation_State_Controller : MonoBehaviour
{
    Animator animator;
    int isWalkingHash;
    int isRunningHash;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        animator = GetComponent<Animator>();

        // Increases performance
        isWalkingHash = Animator.StringToHash("isWalking");
        isRunningHash = Animator.StringToHash("isRunning");
    }

    // Update is called once per frame
    void Update()
    {
        bool isWalking = animator.GetBool(isWalkingHash);
        bool isRunning = animator.GetBool(isRunningHash);
        bool forwardPressed = UnityEngine.Input.GetKey("w");
        bool runPressed = UnityEngine.Input.GetKey("left shift");

        // If player presses w key
        if (!isWalking && forwardPressed)
        {
            // Then set the isWalking boolean to be true
            animator.SetBool(isWalkingHash, true);
        }

        // If player is not pressing w key
        if (isWalking && !forwardPressed)
        {
            // Then set the isWalking boolean to be false
            animator.SetBool(isWalkingHash, false);
        }

        // If player is walking and not running and presses left shift
        if (!isRunning && (forwardPressed && runPressed))
        {
            // Then set the isRunning boolean to be true
            animator.SetBool(isRunningHash, true);
        }

        // If player is running and stops running or stops walking
        if (isRunning && (!forwardPressed || !runPressed))
        {
            // Then set the isRunning boolean to be false
            animator.SetBool(isRunningHash, false);
        }
    }
}
